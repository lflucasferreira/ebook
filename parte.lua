-- Capas de seção (partes temáticas e seções do livro) — PDF, HTML e EPUB

local function split_secao_title(text)
  local separators = {
    '\226\128\148', -- em dash —
    '\226\128\147', -- en dash –
  }

  for _, sep in ipairs(separators) do
    local pos = text:find(sep, 1, true)
    if pos then
      local numero = text:sub(1, pos - 1):match('^%s*(.-)%s*$')
      local nome = text:sub(pos + #sep):match('^%s*(.-)%s*$')
      return numero, nome
    end
  end

  local pos = text:find(' - ', 1, true)
  if pos then
    local numero = text:sub(1, pos - 1):match('^%s*(.-)%s*$')
    local nome = text:sub(pos + 3):match('^%s*(.-)%s*$')
    return numero, nome
  end

  return '', text:match('^%s*(.-)%s*$')
end

local function is_parte_numerada(numero)
  return numero:match('^Parte%s+[IVXLC%d]+') ~= nil
end

local function is_texto_integral_secao(numero, nome, identifier)
  if numero ~= '' then
    return false
  end
  if identifier and identifier:match('^pref') then
    return true
  end
  if identifier and identifier:match('^conclu') then
    return true
  end
  if nome:match('^Pref') then
    return true
  end
  if nome:match('^Conclu') then
    return true
  end
  return false
end

local function should_collect_cover_body(numero)
  if is_parte_numerada(numero) then
    return true
  end
  if numero:match('^[Aa]bertura') then
    return true
  end
  if numero:match('^[Ff]echamento') then
    return true
  end
  return false
end

local function inlines_to_latex(inlines)
  return pandoc.write(pandoc.Pandoc(pandoc.Plain(inlines)), 'latex'):gsub('\n$', '')
end

local function text_to_latex(text)
  return pandoc.write(pandoc.Pandoc(pandoc.Plain({pandoc.Str(text)})), 'latex'):gsub('\n$', '')
end

local function is_front_subhead(block)
  return block.t == 'Header'
    and block.level == 2
    and block.classes:includes('unlisted')
end

local function front_subhead_latex(header)
  local text = text_to_latex(pandoc.utils.stringify(header.content))
  local anchor = header.identifier ~= '' and ('\\hypertarget{' .. header.identifier .. '}{}\n') or ''
  return anchor .. '\\frontsubhead{' .. text .. '}\n'
end

local function transform_front_subheads(blocks)
  if not FORMAT:match('latex') then
    return blocks
  end
  local out = {}
  for _, block in ipairs(blocks) do
    if is_front_subhead(block) then
      table.insert(out, pandoc.RawBlock('latex', front_subhead_latex(block)))
    else
      table.insert(out, block)
    end
  end
  return out
end

local function latex_for_blocks(blocks)
  return pandoc.write(pandoc.Pandoc(transform_front_subheads(blocks)), 'latex')
end

local function is_boundary_block(block)
  if block.t == 'Header' and block.level == 1 then
    return true
  end
  if block.t == 'RawBlock' and block.text:match('\\capituloabertura{') then
    return true
  end
  if block.t == 'RawBlock' and block.text:match('\\chapter{') then
    return true
  end
  return false
end

local function collect_cover_body(blocks, start_index, include_body)
  if not include_body then
    return {}, start_index
  end

  local body = {}
  local i = start_index
  while i <= #blocks do
    local next_block = blocks[i]
    if is_boundary_block(next_block) then
      break
    end
    if next_block.t == 'Header' and next_block.level == 2 then
      break
    end
    table.insert(body, next_block)
    i = i + 1
  end
  return body, i
end

local function collect_until_next_h1(blocks, start_index)
  local body = {}
  local i = start_index
  while i <= #blocks do
    local next_block = blocks[i]
    if is_boundary_block(next_block) then
      break
    end
    table.insert(body, next_block)
    i = i + 1
  end
  return body, i
end

local function is_epigrafe_para(block)
  if block.t ~= 'Para' then
    return false
  end
  local emph_only = true
  local has_text = false
  for _, inl in ipairs(block.content) do
    if inl.t == 'SoftBreak' or inl.t == 'Space' or inl.t == 'LineBreak' then
    elseif inl.t == 'Emph' then
      has_text = true
    else
      emph_only = false
      break
    end
  end
  return has_text and emph_only
end

local function parte_body_latex(blocks)
  local parts = {}
  local start = 1
  if #blocks > 0 and is_epigrafe_para(blocks[1]) then
    local text = pandoc.utils.stringify(blocks[1].content)
    table.insert(parts, string.format('\\parteepigrafe{%s}', text_to_latex(text)))
    start = 2
  end
  for j = start, #blocks do
    if is_front_subhead(blocks[j]) and FORMAT:match('latex') then
      table.insert(parts, front_subhead_latex(blocks[j]))
    else
      table.insert(parts, pandoc.write(pandoc.Pandoc({ blocks[j] }), 'latex'))
    end
  end
  return table.concat(parts, '\n')
end

local function mark_title_tex(block)
  return text_to_latex(pandoc.utils.stringify(block.content))
end

local function secao_header_html(header)
  local text = pandoc.utils.stringify(header.content)
  local numero, nome = split_secao_title(text)
  local content

  if numero ~= '' and nome ~= '' then
    content = {
      pandoc.Span({pandoc.Str(numero)}, {class = 'parte-num'}),
      pandoc.LineBreak(),
      pandoc.Span({pandoc.Str(nome)}, {class = 'parte-nome'}),
    }
  else
    content = header.content
  end

  return pandoc.Header(
    header.level,
    content,
    header.identifier,
    header.classes,
    header.attributes
  )
end

function Pandoc(doc)
  local blocks = {}
  local i = 1

  while i <= #doc.blocks do
    local block = doc.blocks[i]

    if block.t == 'Header' and block.level == 1 and block.classes:includes('parte') then
      local text = pandoc.utils.stringify(block.content)
      local numero, nome = split_secao_title(text)
      local texto_integral = is_texto_integral_secao(numero, nome, block.identifier)
      local include_body = should_collect_cover_body(numero)
      local body, next_i

      if texto_integral then
        body, next_i = collect_until_next_h1(doc.blocks, i + 1)
      else
        body, next_i = collect_cover_body(doc.blocks, i + 1, include_body)
      end

      if FORMAT:match('latex') then
        local anchor = block.identifier ~= '' and block.identifier or 'secao'
        local body_latex = ''
        if #body > 0 then
          if texto_integral then
            body_latex = latex_for_blocks(body)
          else
            body_latex = parte_body_latex(body)
          end
        end

        local numero_tex = numero ~= '' and text_to_latex(numero) or ''
        local nome_tex = nome ~= '' and text_to_latex(nome) or ''
        local titulo_tex = inlines_to_latex(block.content)
        local toc_entry = text_to_latex(pandoc.utils.stringify(block.content))
        local mark_tex = mark_title_tex(block)

        local raw
        if texto_integral then
          raw = table.concat({
            '\\clearpage',
            '\\thispagestyle{empty}',
            '\\phantomsection',
            '\\addcontentsline{toc}{part}{' .. toc_entry .. '}',
            '\\markboth{' .. mark_tex .. '}{' .. mark_tex .. '}',
            '\\hypertarget{' .. anchor .. '}{}',
            '\\begin{parte-prefacio-titulo}',
            string.format('\\partetitulo{%s}', nome_tex),
            '\\end{parte-prefacio-titulo}',
            '',
            body_latex,
            '',
          }, '\n')
        else
          local cover_only = not include_body
          raw = table.concat({
            '\\clearpage',
            '\\thispagestyle{empty}',
            '\\phantomsection',
            '\\addcontentsline{toc}{part}{' .. toc_entry .. '}',
            '\\markboth{' .. mark_tex .. '}{' .. mark_tex .. '}',
            '\\begin{parte}',
            '\\hypertarget{' .. anchor .. '}{}',
            string.format('\\partehead{%s}{%s}', numero_tex, nome_tex),
            '\\begin{partebody}',
            '',
            body_latex,
            '\\end{partebody}',
            '\\end{parte}',
            cover_only and '\\clearpage' or '',
            '',
          }, '\n')
        end

        table.insert(blocks, pandoc.RawBlock('latex', raw))
      elseif FORMAT:match('html') or FORMAT:match('epub') then
        local header = secao_header_html(block)
        if texto_integral then
          if not header.classes then
            header.classes = pandoc.List({'parte', 'secao-terco'})
          else
            header.classes:insert('secao-terco')
            if not header.classes:includes('parte') then
              header.classes:insert('parte')
            end
          end
        end
        table.insert(blocks, pandoc.Div(
          {header},
          pandoc.Attr('', (texto_integral and {'parte-prefacio-titulo'} or {}), {})
        ))
        for idx, b in ipairs(body) do
          if idx == 1 and is_epigrafe_para(b) then
            table.insert(blocks, pandoc.Div({ b }, pandoc.Attr('', { 'parte-epigrafe' }, {})))
          else
            table.insert(blocks, b)
          end
        end
      else
        table.insert(blocks, block)
        for idx, b in ipairs(body) do
          if idx == 1 and is_epigrafe_para(b) then
            table.insert(blocks, pandoc.Div({ b }, pandoc.Attr('', { 'parte-epigrafe' }, {})))
          else
            table.insert(blocks, b)
          end
        end
      end

      i = next_i
    elseif is_front_subhead(block) and FORMAT:match('latex') then
      table.insert(blocks, pandoc.RawBlock('latex', front_subhead_latex(block)))
      i = i + 1
    else
      table.insert(blocks, block)
      i = i + 1
    end
  end

  doc.blocks = blocks
  return doc
end
