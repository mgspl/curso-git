local sampleNames = { "Maria", "Lucia", "Arthur", "Boris", "Newton" }
local testN = 10000
local users = {}
local order = true

local function userSort(a, b)
  return b.name > a.name
end

function registerUser(name)
  local lowerName = string.lower(name)
  table.insert(users, { id = #users, name = lowerName })
  if order then
    table.sort(users, userSort)
  end
end

function registerUsers(names)
  order = false
  for _,name in ipairs(names) do
    registerUser(name)
  end
  table.sort(users, userSort)
  order = true
end

function main()
  local names = {}
  local n = #sampleNames
  for i=1,testN do
    names[i] = sampleNames[((i-1) % n)+1]  .. i
  end

  registerUser('Fulano')
  registerUsers(names)
  registerUser('Beltrano')
  print('Users registered: ', #users)
end

main()
