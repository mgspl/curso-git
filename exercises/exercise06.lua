local users = { }

local function validateUser(user)
  if utf8.len(user.name) < 4 then
    print("[ERRO] O nome do usuário precisa ter no mínimo 4 caracteres")
    return false
  end

  if user.age <= 18 then
    print("[ERRO] O usuário precisar ser maior de 18 anos")
    return false
  end

  return true
end

local function addUser(newName, newAge)
  newUser = { name = newName, age = newAge }

  if validateUser(newUser) then
    table.insert(users, newUser)
    print("Usuário adicionado corretamente!")
  end
end

local function removeUser(id)
  if id > #users then
    print('[ERRO] Usuário não encontrado')
  end

  table.remove(users, id)
end

local function printUsers(users)
  for i, user in pairs(users) do
    io.write(i .. ' - ' .. 'Nome: ' .. user.name .. ' - Idade: ' .. user.age .. '\n')
  end
end

addUser('João', 20)
addUser('Maria', 25)
addUser('Miguel', 24)
addUser('Fulano', 16)
addUser('Jão', 20)
addUser('Beltrano', 28)

printUsers(users)

removeUser(5)
removeUser(2)

printUsers(users)
