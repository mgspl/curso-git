local list = {1, 2, 3, 4, 5}

print("Primeiro valor: " .. list[1] .. " | Último valor: " .. list[5])

list[2] = 20
list[4] = 40

table.insert(list, 6)

io.write("Lista completa: ")
for _, value in pairs(list) do
  io.write(value, " ")
end
-- Quebrando uma linha para melhorar a visualização do conteúdo
io.write("\n")

local newValue = 7

table.insert(list, newValue)
newValue = 70

print("Valor dentro da Lista: " .. list[7])
print("Valor de fora da Lista: " .. newValue)
