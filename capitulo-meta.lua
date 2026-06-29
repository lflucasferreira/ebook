-- Converte ::: capitulo-meta em ambiente LaTeX no PDF
function Div(el)
  if not el.classes:includes('capitulo-meta') then
    return nil
  end

  if FORMAT:match('latex') then
    local doc = pandoc.Pandoc(el.content)
    local body = pandoc.write(doc, 'latex')
    return pandoc.RawBlock(
      'latex',
      '\\begin{capitulo-meta}\n' .. body .. '\\end{capitulo-meta}\n'
    )
  end

  return nil
end
