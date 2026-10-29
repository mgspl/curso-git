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

local function serialize(t, maxDepth, indent, level)
  if type(t) == "number" or type(t) == "boolean" then
    return tostring(t)
  elseif type(t) ~= "table" or level > maxDepth then
    return string.format("%q", tostring(t))
  end

  local prefix = string.rep(indent, level)
  local st = {}

  for k, v in pairs(t) do
    if not (type(k) == "number" and k >= 1 and k <= #t) then
      table.insert(st, prefix .. "[" .. serialize(k, 0, "", 1) .. "] = " .. serialize(v, maxDepth, indent, level + 1))
    else
      table.insert(st, prefix .. serialize(t[k], maxDepth, indent, level + 1))
    end
  end

  return "{\n" .. table.concat(st, ",\n") .. "\n" .. string.rep(indent, level - 1) .. "}"
end


function table.tostring(t, maxDepth, indent)
  local text = serialize(t, maxDepth, indent, 1)
  assert(loadstring("return " .. text))
  return text
end

function main()
  local rootElement = setupRootElement()
  print(table.tostring(rootElement, 3, ' '))
end

main()
