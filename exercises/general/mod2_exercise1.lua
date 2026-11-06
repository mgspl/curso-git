function setupRootElement()
  local root = {}
  root.id = 'rootElement'
  root.visible = true
  root.color = 'red'
  root['background color'] = 'yellow'
  root.text = 'Main Window'
  root.children = {
    { id = 'child1', zOrder = 1, visible = true, parent = root },
    { id = 'child2', zOrder = 2, visible = true, parent = root },
    { id = 'child3', zOrder = 3, visible = false, clickVolume = 0.02, parent = root },
  }
  root.savedIndexes = { 4, 1, 3, 2, 5, total = 5 }
  root.layoutPositions = { 'top', 'left', 'bottom', 'right' }
  root.innerLengths = { x = 1, l = { x = 2, l = { x = 3, l = { x = 4, l = { x = 5, l = { x = 6 } } } } } }

  return root
end

local function serialize(t, maxDepth, indent, level, seen, buf)
  if type(t) == "number" or type(t) == "boolean" then
    buf[#buf + 1] = tostring(t)
    return
  elseif seen[t] then
    buf[#buf + 1] = string.format("%q", tostring(t))
    return
  elseif type(t) ~= "table" or level > maxDepth then
    buf[#buf + 1] = string.format("%q", tostring(t))
    return
  end

  seen[t] = true
  buf[#buf + 1] = "{\n"
  local child_ident = string.rep(indent, level)

  for k, v in pairs(t) do
    buf[#buf + 1] = child_ident
    if type(k) ~= "number" then
      buf[#buf + 1] = '["'
      buf[#buf + 1] =  tostring(k)
      buf[#buf + 1] = '"] = '
    end
      serialize(v, maxDepth, indent, level + 1, seen, buf)
      buf[#buf + 1] = ",\n"
  end
  buf[#buf + 1] = string.rep(indent, level - 1)
  buf[#buf + 1] = "}"

end

function table.tostring(t, maxDepth, indent)
  local seen = {}
  local buf = {}
  serialize(t, maxDepth, indent, 1, seen, buf)
  local text = table.concat(buf)
  assert(loadstring("return " .. text))
  return text
end

function main()
  local rootElement = setupRootElement()
  print(table.tostring(rootElement, 3, ' '))
end

main()
