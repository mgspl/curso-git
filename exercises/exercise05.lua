local map = {
  { ".", ".", "." },
  { ".", ".", "." },
  { ".", ".", "." }
}

local player = {
  name = "Mizigiri",
  posX = 2,
  posY = 2
}

map[player.posX][player.posY] = "P"

for _, row in pairs(map) do
  for _, column in pairs(row) do
    io.write(column)
  end
  io.write("\n")
end

print("")

map[player.posX][player.posY] = "."

player.posX = player.posX + 1
player.posY = player.posY + 1

map[player.posX][player.posY] = "P"

for _, row in pairs(map) do
  for _, column in pairs(row) do
    io.write(column)
  end
  io.write("\n")
end
