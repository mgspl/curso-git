local sampleNames = { "Maria", "Lucia", "Arthur", "Boris", "Newton" }
local testN = 10000
local users = {}

local function userSort(a, b)
  return b.name > a.name
end

local function commitUser(name)
  local lowerName = string.lower(name)
  table.insert(users, { id = #users, name = lowerName })
end

function registerUser(name)
  commitUser(name)
  table.sort(users, userSort)
end

function registerUsers(names)
  for _,name in ipairs(names) do
    commitUser(name)
  end
  table.sort(users, userSort)
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
