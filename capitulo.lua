-- Abertura moderna de capítulos — PDF, HTML e EPUB

local function split_capitulo_title(text)
  local numero = text:match('^(Capítulo%s+%d+)')
  if not numero then
    return text, ''
  end

  local rest = text:sub(#numero + 1):match('^%s*(.*)$')
  local separators = {
    '\226\128\148', -- em dash —
    '\226\128\147', -- en dash –
  }

  for _, sep in ipairs(separators) do
    if rest:sub(1, #sep) == sep then
      local titulo = rest:sub(#sep + 1):match('^%s*(.-)%s*$')
      return numero, titulo or ''
    end
  end

  local pos = rest:find(' - ', 1, true)
  if pos then
    local titulo = rest:sub(pos + 3):match('^%s*(.-)%s*$')
    return numero, titulo or ''
  end

  return numero, (rest:match('^%s*(.-)%s*$') or '')
end

local function is_capitulo_header(header)
  if header.level ~= 1 then
    return false
  end
  local text = pandoc.utils.stringify(header.content)
  return text:match('^Capítulo%s+%d+') ~= nil
end

local function text_to_latex(text)
  return pandoc.write(pandoc.Pandoc(pandoc.Plain({pandoc.Str(text)})), 'latex'):gsub('\n$', '')
end

local function capitulo_header_html(header)
  local text = pandoc.utils.stringify(header.content)
  local numero, titulo = split_capitulo_title(text)
  local content

  if titulo ~= '' then
    content = {
      pandoc.Span({pandoc.Str(numero)}, {class = 'capitulo-num'}),
      pandoc.LineBreak(),
      pandoc.Span({pandoc.Str(titulo)}, {class = 'capitulo-titulo'}),
    }
  else
    content = header.content
  end

  if not header.classes then
    header.classes = pandoc.List({'capitulo'})
  else
    header.classes:insert('capitulo')
  end

  return pandoc.Header(
    header.level,
    content,
    header.identifier,
    header.classes,
    header.attributes
  )
end

local function is_epigrafe_autor_para(block)
  if block.t ~= 'Para' then
    return false
  end
  local text = pandoc.utils.stringify(block.content)
  local emdash = '\226\128\148'
  return text:match('^%-%-%-') ~= nil or text:sub(1, #emdash) == emdash
end

local function epigrafe_body_latex(content)
  local parts = {}
  for idx, block in ipairs(content) do
    if block.t == 'Para' and idx == #content and is_epigrafe_autor_para(block) then
      local inner = text_to_latex(pandoc.utils.stringify(block.content))
      table.insert(parts, '\\epigrafeautor{' .. inner .. '}')
    elseif block.t == 'Para' then
      local inner = text_to_latex(pandoc.utils.stringify(block.content))
      table.insert(parts, '\\epigrafequote{' .. inner .. '}')
    else
      table.insert(parts, pandoc.write(pandoc.Pandoc({block}), 'latex'))
    end
  end
  return table.concat(parts, '\n')
end

local function parse_capitulo_ficha(content)
  local tema, origem = '', ''
  for _, block in ipairs(content) do
    if block.t == 'Para' then
      local mode = nil
      local tema_parts, origem_parts = {}, {}
      for _, inl in ipairs(block.content) do
        if inl.t == 'LineBreak' then
          mode = 'origem'
        elseif inl.t == 'Strong' then
          local label = pandoc.utils.stringify(inl.content)
          if label:match('^Tema') then
            mode = 'tema'
          elseif label:match('^Origem') then
            mode = 'origem'
          end
        elseif mode == 'tema' then
          table.insert(tema_parts, inl)
        elseif mode == 'origem' then
          table.insert(origem_parts, inl)
        end
      end
      tema = pandoc.utils.stringify(tema_parts):match('^%s*(.-)%s*$') or ''
      origem = pandoc.utils.stringify(origem_parts):match('^%s*(.-)%s*$') or ''
    end
  end
  return tema, origem
end

local function parse_qa_card_item(content)
  local label, prompt, body = '', '', ''
  local para_index = 0
  for _, block in ipairs(content) do
    if block.t == 'Para' then
      para_index = para_index + 1
      local text = pandoc.utils.stringify(block.content):match('^%s*(.-)%s*$') or ''
      if para_index == 1 then
        label = text:gsub('^%*%*(.-)%*%*$', '%1')
      elseif para_index == 2 then
        prompt = text
      elseif para_index == 3 then
        body = text
      end
    end
  end
  return label, prompt, body
end

local function inlines_slice(inls, from_idx, to_idx)
  local out = pandoc.List()
  for i = from_idx, to_idx do
    out:insert(inls[i])
  end
  return out
end

local function parse_status_item(content)
  local label, body = '', ''
  for _, block in ipairs(content) do
    if block.t == 'Para' then
      local inls = block.content
      local break_at = nil
      for i, inl in ipairs(inls) do
        if inl.t == 'LineBreak' or inl.t == 'SoftBreak' then
          break_at = i
          break
        end
      end
      if break_at then
        label = pandoc.utils.stringify(inlines_slice(inls, 1, break_at - 1)):match('^%s*(.-)%s*$') or ''
        body = pandoc.utils.stringify(inlines_slice(inls, break_at + 1, #inls)):match('^%s*(.-)%s*$') or ''
      elseif label == '' then
        label = pandoc.utils.stringify(block.content):match('^%s*(.-)%s*$') or ''
      else
        body = pandoc.utils.stringify(block.content):match('^%s*(.-)%s*$') or ''
      end
    end
  end
  label = label:gsub('^%*%*(.-)%*%*$', '%1')
  if body == '' and label:find('\n', 1, true) then
    local line_label, line_body = label:match('^(.-)\n(.*)$')
    if line_label then
      label, body = line_label, line_body
    end
  end
  return label, body
end

local function status_icon(label, for_latex)
  if for_latex then
    if label:match('^[Ff]echado') then
      return '\\qastatusicdone'
    end
    if label:match('^[Ee]ncontrado') then
      return '\\qastatusicfind'
    end
    if label:match('^[Pp]r') then
      return '\\qastatusicnext'
    end
    if label:match('^[Rr]elease') then
      return '\\qastatusicrel'
    end
    return '\\qastatusicdot'
  end
  return '•'
end

local function row_type_class(label)
  if label:match('^[Ff]echado') then return 'type-fechado' end
  if label:match('^[Ee]ncontrado') then return 'type-encontrado' end
  if label:match('^[Pp]r') then return 'type-proximo' end
  if label:match('^[Rr]elease') then return 'type-release' end
  return 'type-other'
end

local function qa_status_variant(el)
  if el.classes:includes('fraco') then
    return 'fraco'
  end
  if el.classes:includes('modelo') then
    return 'modelo'
  end
  return 'exemplo'
end

local function render_qa_status(el)
  local title, rows = '', {}
  for _, child in ipairs(el.content) do
    if child.t == 'Para' then
      title = pandoc.utils.stringify(child.content):gsub('^%*%*(.-)%*%$', '%1')
    elseif child.t == 'Div' and child.classes:includes('qa-status-item') then
      local label, body = parse_status_item(child.content)
      table.insert(rows, { label, body, status_icon(label, false) })
    end
  end

  if title == '' or #rows == 0 then
    return el
  end

  local variant = qa_status_variant(el)

  if FORMAT:match('latex') then
    local parts = { string.format('\\qastatuscard{%s}{%s}{\n', variant, text_to_latex(title)) }
    for i, row in ipairs(rows) do
      local cmd = (i == #rows) and '\\qastatusrowlast' or '\\qastatusrow'
      table.insert(parts, string.format(
        cmd .. '{%s}{%s}{%s}{%s}\n',
        variant,
        status_icon(row[1], true),
        text_to_latex(row[1]),
        text_to_latex(row[2])
      ))
    end
    table.insert(parts, '}\n')
    return pandoc.RawBlock('latex', table.concat(parts))
  end

  if FORMAT:match('html') or FORMAT:match('epub') then
    local html_rows = {}
    for i, row in ipairs(rows) do
      local label, body, icon = row[1], row[2], row[3]
      local body_inls = { pandoc.Str(body) }
      if variant == 'modelo' then
        body_inls = { pandoc.Emph({ pandoc.Str(body) }) }
      end
      local row_classes = { 'qa-status-row', row_type_class(label) }
      if i == #rows then
        table.insert(row_classes, 'qa-status-row-last')
      end
      table.insert(html_rows, pandoc.Div({
        pandoc.Span({ pandoc.Str(icon) }, pandoc.Attr('', { 'qa-status-icon' }, {})),
        pandoc.Span({ pandoc.Str(label) }, pandoc.Attr('', { 'qa-status-label' }, {})),
        pandoc.Para(body_inls, pandoc.Attr('', { 'qa-status-body' }, {})),
      }, pandoc.Attr('', row_classes, {})))
    end
    local card_content = {
      pandoc.Div({ pandoc.Str(title) }, pandoc.Attr('', { 'qa-status-head' }, {})),
    }
    for _, row in ipairs(html_rows) do
      table.insert(card_content, row)
    end
    return pandoc.Div(card_content, pandoc.Attr('', { 'qa-status', variant }, {}))
  end

  return el
end

local function game_step_meta(label)
  local lower = label:lower()
  if lower:match('^goal') then return 'game-item--goal', 'G' end
  if lower:match('^action') then return 'game-item--action', 'A' end
  if lower:match('^measure') then return 'game-item--measure', 'M' end
  if lower:match('^expectation') then return 'game-item--expectation', 'E' end
  return '', ''
end

local function render_game(el)
  local items = {}
  for _, child in ipairs(el.content) do
    if child.t == 'Div' and child.classes:includes('game-item') then
      local label, prompt, body = parse_qa_card_item(child.content)
      table.insert(items, { label, prompt, body })
    end
  end

  if #items == 0 then
    return el
  end

  local function game_item_latex(label, prompt, example, metricas)
    local cmd = metricas and '\\gamemetricitem' or '\\gameitem'
    return string.format(
      cmd .. '{%s}{%s}{%s}',
      text_to_latex(label),
      text_to_latex(prompt),
      text_to_latex(example)
    )
  end

  if FORMAT:match('latex') and el.classes:includes('game-grid') then
    local parts = { '\\begin{gamegrid}\n' }
    for i = 1, #items, 2 do
      local left = game_item_latex(items[i][1], items[i][2], items[i][3], false)
      if items[i + 1] then
        local right = game_item_latex(items[i + 1][1], items[i + 1][2], items[i + 1][3], false)
        table.insert(parts, string.format('\\gamegridrow{%s}{%s}\n', left, right))
      else
        table.insert(parts, left .. '\n')
      end
    end
    table.insert(parts, '\\end{gamegrid}\n')
    return pandoc.RawBlock('latex', table.concat(parts))
  end

  if FORMAT:match('latex') then
    local parts = { '\\begin{game}\n' }
    local is_metricas = el.classes:includes('metricas')
    local cmd = is_metricas and '\\gamemetricitem' or '\\gameitem'
    for _, item in ipairs(items) do
      local label, prompt, example = item[1], item[2], item[3]
      table.insert(parts, string.format(
        cmd .. '{%s}{%s}{%s}\n',
        text_to_latex(label),
        text_to_latex(prompt),
        text_to_latex(example)
      ))
    end
    table.insert(parts, '\\end{game}\n')
    return pandoc.RawBlock('latex', table.concat(parts))
  end

  if FORMAT:match('html') or FORMAT:match('epub') then
    local cards = {}
    for _, item in ipairs(items) do
      local label, prompt, example = item[1], item[2], item[3]
      local step_class, letter = game_step_meta(label)
      local item_classes = { 'game-item' }
      if step_class ~= '' then
        table.insert(item_classes, step_class)
      end
      local card_children = {}
      if letter ~= '' then
        table.insert(card_children, pandoc.Span(
          { pandoc.Str(letter) },
          pandoc.Attr('', { 'game-item-letter' }, {})
        ))
      end
      table.insert(card_children, pandoc.Div({
        pandoc.Div({
          pandoc.Span({ pandoc.Str(label) }, pandoc.Attr('', { 'game-item-label' }, {})),
          pandoc.Span({ pandoc.Str(prompt) }, pandoc.Attr('', { 'game-item-prompt' }, {})),
        }, pandoc.Attr('', { 'game-item-header' }, {})),
        pandoc.Para(
          { pandoc.Emph({ pandoc.Str(example) }) },
          pandoc.Attr('', { 'game-item-example' }, {})
        ),
      }, pandoc.Attr('', { 'game-item-body' }, {})))
      table.insert(cards, pandoc.Div(card_children, pandoc.Attr('', item_classes, {})))
    end
    return pandoc.Div(cards, pandoc.Attr('', el.classes, {}))
  end

  return el
end

local function block_to_latex(block)
  return pandoc.write(pandoc.Pandoc({ block }), 'latex'):gsub('\n+$', '')
end

local function render_game_spread_hero(el)
  local title, acronym = '', ''
  for _, block in ipairs(el.content) do
    if block.t == 'Header' then
      title = pandoc.utils.stringify(block.content)
    elseif block.t == 'Para' then
      acronym = block_to_latex(block)
    end
  end

  if FORMAT:match('latex') then
    local parts = {}
    if title ~= '' then
      table.insert(parts, '\\gamespreadtitle{' .. text_to_latex(title) .. '}\n')
    end
    if acronym ~= '' then
      table.insert(parts, '\\gamespreadacronym{' .. acronym .. '}\n')
    end
    return pandoc.RawBlock('latex', table.concat(parts))
  end

  if FORMAT:match('html') or FORMAT:match('epub') then
    return pandoc.Div(el.content, pandoc.Attr('', { 'game-spread-hero' }, {}))
  end

  return el
end

local function render_game_spread_block(el, latex_cmd)
  if FORMAT:match('latex') then
    local chunks = {}
    for i, block in ipairs(el.content) do
      chunks[i] = block_to_latex(block)
    end
    return pandoc.RawBlock('latex', '\\' .. latex_cmd .. '{' .. table.concat(chunks, '\\par ') .. '}\n')
  end

  if FORMAT:match('html') or FORMAT:match('epub') then
    return pandoc.Div(el.content, pandoc.Attr('', el.classes, {}))
  end

  return el
end

local function render_spread_child(child)
  if child.t ~= 'Div' then
    return child
  end
  if child.classes:includes('game-spread-hero') then
    return render_game_spread_hero(child)
  end
  if child.classes:includes('game-spread-intro')
      or child.classes:includes('game-spread-rule')
      or child.classes:includes('game-spread-footer')
      or child.classes:includes('game-spread-channels') then
    return render_game_spread_block(child, '')
  end
  if child.classes:includes('game') then
    return render_game(child)
  end
  if child.classes:includes('game-item') then
    return {}
  end
  return child
end

local function render_game_spread(el)
  if FORMAT:match('latex') then
    local parts = { '\\begin{gamespread}\n' }
    for _, child in ipairs(el.content) do
      if child.t == 'Div' then
        if child.classes:includes('game-spread-hero') then
          local rendered = render_game_spread_hero(child)
          if rendered.t == 'RawBlock' then
            table.insert(parts, rendered.text)
          end
        elseif child.classes:includes('game-spread-intro') then
          local rendered = render_game_spread_block(child, 'gamespreadintro')
          if rendered.t == 'RawBlock' then
            table.insert(parts, rendered.text)
          end
        elseif child.classes:includes('game-spread-rule') then
          local rendered = render_game_spread_block(child, 'gamespreadrule')
          if rendered.t == 'RawBlock' then
            table.insert(parts, rendered.text)
          end
        elseif child.classes:includes('game-spread-footer') then
          local rendered = render_game_spread_block(child, 'gamespreadfooter')
          if rendered.t == 'RawBlock' then
            table.insert(parts, rendered.text)
          end
        elseif child.classes:includes('game-spread-channels') then
          local rendered = render_game_spread_block(child, 'gamespreadchannels')
          if rendered.t == 'RawBlock' then
            table.insert(parts, rendered.text)
          end
        elseif child.classes:includes('game') then
          local rendered = render_game(child)
          if rendered.t == 'RawBlock' then
            table.insert(parts, rendered.text)
          end
        end
      elseif child.t == 'Para' then
        table.insert(parts, '\\gamespreadpara{' .. block_to_latex(child) .. '}\n')
      end
    end
    table.insert(parts, '\\end{gamespread}\n')
    return pandoc.RawBlock('latex', table.concat(parts))
  end

  if FORMAT:match('html') or FORMAT:match('epub') then
    local children = {}
    for _, child in ipairs(el.content) do
      table.insert(children, render_spread_child(child))
    end
    return pandoc.Div(children, pandoc.Attr('', { 'game-spread' }, {}))
  end

  return el
end

local function render_qa_canal(el)
  local items = {}
  for _, child in ipairs(el.content) do
    if child.t == 'Div' and child.classes:includes('qa-canal-item') then
      local label, freq, uso = parse_qa_card_item(child.content)
      table.insert(items, { label, freq, uso })
    end
  end

  if #items == 0 then
    return el
  end

  if FORMAT:match('latex') then
    local parts = { '\\begin{qacanal}\n' }
    for _, item in ipairs(items) do
      table.insert(parts, string.format(
        '\\qacanalitem{%s}{%s}{%s}\n',
        text_to_latex(item[1]),
        text_to_latex(item[2]),
        text_to_latex(item[3])
      ))
    end
    table.insert(parts, '\\end{qacanal}\n')
    return pandoc.RawBlock('latex', table.concat(parts))
  end

  if FORMAT:match('html') or FORMAT:match('epub') then
    local cards = {}
    for _, item in ipairs(items) do
      table.insert(cards, pandoc.Div({
        pandoc.Div({
          pandoc.Span({ pandoc.Str(item[1]) }, pandoc.Attr('', { 'qa-canal-item-label' }, {})),
          pandoc.Span({ pandoc.Str(item[2]) }, pandoc.Attr('', { 'qa-canal-item-freq' }, {})),
        }, pandoc.Attr('', { 'qa-canal-item-header' }, {})),
        pandoc.Para(
          { pandoc.Str(item[3]) },
          pandoc.Attr('', { 'qa-canal-item-body' }, {})
        ),
      }, pandoc.Attr('', { 'qa-canal-item' }, {})))
    end
    return pandoc.Div(cards, pandoc.Attr('', { 'qa-canal' }, {}))
  end

  return el
end

local function is_passos_praticos_header(header)
  if header.level ~= 2 then
    return false
  end
  local text = pandoc.utils.stringify(header.content):lower()
  return text:match('^passos pr') ~= nil
end

local function process_div(el)
  if el.classes:includes('game-spread') then
    return render_game_spread(el)
  end

  if el.classes:includes('game-spread-hero') then
    return render_game_spread_hero(el)
  end

  if el.classes:includes('game-spread-intro') then
    return render_game_spread_block(el, 'gamespreadintro')
  end

  if el.classes:includes('game-spread-rule') then
    return render_game_spread_block(el, 'gamespreadrule')
  end

  if el.classes:includes('game-spread-footer') then
    return render_game_spread_block(el, 'gamespreadfooter')
  end

  if el.classes:includes('game-spread-channels') then
    return render_game_spread_block(el, 'gamespreadchannels')
  end

  if el.classes:includes('game') then
    return render_game(el)
  end

  if el.classes:includes('game-item') then
    return {}
  end

  if el.classes:includes('qa-canal') then
    return render_qa_canal(el)
  end

  if el.classes:includes('qa-canal-item') then
    return {}
  end

  if el.classes:includes('qa-status') then
    return render_qa_status(el)
  end

  if el.classes:includes('qa-status-item') then
    return {}
  end

  if el.classes:includes('capitulo-meta') then
    -- Metadados ficam em 100-referencias.md, não no corpo do capítulo
    return {}
  end

  if el.classes:includes('capitulo-ficha') then
    local tema, origem = parse_capitulo_ficha(el.content)
    if FORMAT:match('latex') then
      return pandoc.RawBlock(
        'latex',
        string.format(
          '\\capituloficha{%s}{%s}\n',
          text_to_latex(tema),
          text_to_latex(origem)
        )
      )
    end
    if FORMAT:match('html') or FORMAT:match('epub') then
      return pandoc.Div({
        pandoc.Para(
          { pandoc.Strong({ pandoc.Str('Tema:') }), pandoc.Str(' ' .. tema) },
          pandoc.Attr('', { 'capitulo-ficha-tema' }, {})
        ),
        pandoc.Para(
          { pandoc.Strong({ pandoc.Str('Origem:') }), pandoc.Str(' ' .. origem) },
          pandoc.Attr('', { 'capitulo-ficha-origem' }, {})
        ),
      }, pandoc.Attr('', { 'capitulo-ficha' }, {}))
    end
    return el
  end

  if el.classes:includes('capitulo-epigrafe') then
    if FORMAT:match('latex') then
      local body = epigrafe_body_latex(el.content)
      return pandoc.RawBlock(
        'latex',
        '\\begin{capitulo-epigrafe}\n' .. body .. '\\end{capitulo-epigrafe}\n'
      )
    end
    el.classes:insert('epigrafe-capitulo')
    return el
  end

  return el
end

function Pandoc(doc)
  local blocks = {}
  local capitulo_inicio_aberto = false
  local fechar_inicio_no_proximo_para = false
  local dentro_capitulo = false
  local quebrar_apos_passos = false
  local i = 1

  local function fechar_capitulo_inicio()
    if capitulo_inicio_aberto and FORMAT:match('latex') then
      table.insert(blocks, pandoc.RawBlock('latex', '\\end{capitulo-inicio}\n'))
      capitulo_inicio_aberto = false
      fechar_inicio_no_proximo_para = false
    end
  end

  while i <= #doc.blocks do
    local block = doc.blocks[i]

    if block.t == 'Header' and block.level == 1 and capitulo_inicio_aberto then
      fechar_capitulo_inicio()
    end

    if block.t == 'Header' and is_capitulo_header(block) then
      dentro_capitulo = true
      quebrar_apos_passos = false
      local numero, titulo = split_capitulo_title(pandoc.utils.stringify(block.content))

      if FORMAT:match('latex') then
        local numero_tex = text_to_latex(numero)
        local titulo_tex = text_to_latex(titulo)
        table.insert(blocks, pandoc.RawBlock('latex', table.concat({
          '\\clearpage',
          '\\capituloabertura{' .. numero_tex .. '}{' .. titulo_tex .. '}',
          '\\begin{capitulo-inicio}',
          '',
        }, '\n')))
        capitulo_inicio_aberto = true
        fechar_inicio_no_proximo_para = true
      elseif FORMAT:match('html') or FORMAT:match('epub') then
        table.insert(blocks, capitulo_header_html(block))
      else
        table.insert(blocks, block)
      end
    elseif block.t == 'Header' and block.level == 1
        and block.classes:includes('unnumbered')
        and not block.classes:includes('parte')
        and not is_capitulo_header(block) then
      if FORMAT:match('latex') then
        local title_tex = text_to_latex(pandoc.utils.stringify(block.content))
        local anchor = block.identifier ~= '' and block.identifier or ''
        local anchor_tex = anchor ~= '' and ('\\hypertarget{' .. anchor .. '}{}\n') or ''
        table.insert(blocks, pandoc.RawBlock('latex', table.concat({
          '\\cleardoublepage',
          '\\markboth{' .. title_tex .. '}{' .. title_tex .. '}',
          '\\addcontentsline{toc}{chapter}{' .. title_tex .. '}',
          '\\thispagestyle{empty}',
          anchor_tex,
          '\\capitulotitulo{' .. title_tex .. '}\\par\\vspace{0.75em}',
          '\\par\\normalfont\\normalsize',
          '\\begin{capitulo-inicio}',
          '',
        }, '\n')))
        capitulo_inicio_aberto = true
        fechar_inicio_no_proximo_para = true
      elseif FORMAT:match('html') or FORMAT:match('epub') then
        table.insert(blocks, block)
      else
        table.insert(blocks, block)
      end
    elseif block.t == 'Header' and block.level == 2 and quebrar_apos_passos and dentro_capitulo then
      quebrar_apos_passos = false
      if FORMAT:match('latex') then
        table.insert(blocks, pandoc.RawBlock('latex', '\\clearpage\n'))
      end
      if FORMAT:match('html') or FORMAT:match('epub') then
        block.classes:insert('apos-passos-praticos')
      end
      table.insert(blocks, block)
    elseif block.t == 'Header' and is_passos_praticos_header(block) and dentro_capitulo then
      quebrar_apos_passos = true
      table.insert(blocks, block)
    elseif block.t == 'Div' then
      table.insert(blocks, process_div(block))
    elseif block.t == 'Para' and fechar_inicio_no_proximo_para then
      table.insert(blocks, block)
      fechar_capitulo_inicio()
    else
      table.insert(blocks, block)
    end

    i = i + 1
  end

  fechar_capitulo_inicio()

  doc.blocks = blocks
  return doc
end
