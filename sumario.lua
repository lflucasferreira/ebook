-- Sumário: Prefácio, Introdução e Abertura entram só no nível do título (sem H2 internos)

local function is_front_matter_h1(header)
  if header.level ~= 1 or not header.classes:includes('parte') then
    return false
  end
  local text = pandoc.utils.stringify(header.content)
  return text:match('^Pref')
    or text:match('^Introdu')
    or text:match('^[Aa]bertura') ~= nil
end

function Pandoc(doc)
  local in_front_matter = false
  local blocks = {}

  for _, block in ipairs(doc.blocks) do
    if block.t == 'Header' and block.level == 1 then
      in_front_matter = is_front_matter_h1(block)
    elseif block.t == 'Header' and block.level == 2 and in_front_matter then
      if not block.classes then
        block.classes = pandoc.List({})
      end
      block.classes:insert('unlisted')
    end
    table.insert(blocks, block)
  end

  doc.blocks = blocks
  return doc
end
