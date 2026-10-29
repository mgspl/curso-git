local CFG = {
  FLEET = 5,
  MAP = {
    {"A1", "A2", "A3", "A4", "A5"},
    {"B1", "B2", "B3", "B4", "B5"},
    {"C1", "C2", "C3", "C4", "C5"},
    {"D1", "D2", "D3", "D4", "D5"},
    {"E1", "E2", "E3", "E4", "E5"}
  },
  ROWS = {
    A = 1,
    B = 2,
    C = 3,
    D = 4,
    E = 5
  },
  UI = {
    SHIP = "_P",
    MISS = "XX",
    HIT = "00"
  }
}

local mapRows = #CFG.MAP
local mapColumns = #CFG.MAP[1]
local playerWin = false
local playerFleet = {}
local playerFleetSize = 0
local playerAttacks = {}
local playerAttackHits = 0
local playerAttackMiss = 0
local npcWin = false
local npcFleet = {}
local npcFleetSize = 0
local npcAttacks = 0
local npcAttackHits = 0
local npcAttackMiss = 0
local npcValidAttacks = {}

local function splitInput(input)
  local row = string.match(input, '%a')
  local column = string.match(input, '%d')

  if not row or not column then
    return false
  end

  local validRow = false
  for k, v in pairs(CFG.ROWS) do
    if row == k then
      validRow = true
      break
    end
  end

  if not validRow then
    return false
  end

  local row = string.gsub(row, "%u", CFG.ROWS, 1)

  if tonumber(row) > mapRows or tonumber(column) > mapColumns then
    return false
  end

  return row, column
end

local function splitCoords(coords)
  local row = string.match(coords, '%d', 1)
  local column = string.match(coords, '%d', 2)

  return tonumber(row), tonumber(column)
end

local function validateInput(input)
  local row, column = splitInput(input)

  if not row or not column then
    return false
  end

  local ship = row .. column

  return ship
end

local function isValidCoords(coord, table)
   for i = 1, #table do
      if table[i] == coord then
        return false
      end
    end

    return true
end

local function copyMap()
  local newMap = {}
  for _, row in pairs(CFG.MAP) do
    local mapRow = {}
    for _, column in pairs(row) do
      table.insert(mapRow, column)
    end
    table.insert(newMap, mapRow)
  end
  return newMap
end

local function printMap(map)
  for _, row in pairs(map) do
    for _, column in pairs(row) do
      io.write(column, " ")
    end
    io.write("\n")
  end
end

local function initNpc()
  for i = 1, mapRows do
    for k = 1, mapColumns do
      table.insert(npcValidAttacks, i .. k)
    end
  end

  while npcFleetSize < CFG.FLEET do
    local id = math.random(1, #npcValidAttacks)

    local newShip = isValidCoords(npcValidAttacks[id], npcFleet)
    if newShip then
      table.insert(npcFleet, npcValidAttacks[id])
      npcFleetSize = npcFleetSize + 1
    end
  end
end

local function deployShip(fleet, map)
  for i = 1, #fleet do
    local row, column =  splitCoords(fleet[i])
    map[row][column] = CFG.UI.SHIP
  end
end

local function processAttack(coords, fleet, map)
  local row, column = splitCoords(coords)
  local missed = isValidCoords(coords, fleet)

  -- Return false to ensure a new attack attempt
  if missed then
    map[row][column] = CFG.UI.MISS
    return false
  end

  map[row][column] = CFG.UI.HIT
  for i = 1, #fleet do
    if coords == fleet[i] then
      table.remove(fleet, i)
    end
  end
  return true
end

local playerMap = copyMap()
local npcMap = copyMap()

local function gameHUD()
  print("JOGADOR:")
  print("Acertos:", playerAttackHits, "Erros:", playerAttackMiss, "Total:", #playerAttacks)
  print("Frota:", #playerFleet .. "/" .. CFG.FLEET)
  printMap(playerMap)
  io.write("\n")
  print("INIMIGO:")
  print("Acertos:", npcAttackHits, "Erros:", npcAttackMiss, "Total:", npcAttacks)
  print("Frota:", #npcFleet .. "/" .. CFG.FLEET)
  printMap(npcMap)
  io.write("\n")
end

repeat
  print("Selecione as posições dos navios:")
  printMap(playerMap)
  local input = io.read(2):upper()
  _ = io.stdin:read("*l")

  local shipPos = validateInput(input)
  local validShip = isValidCoords(shipPos, playerFleet)

  if validShip and shipPos then
    table.insert(playerFleet, shipPos)
    playerFleetSize = playerFleetSize + 1
    deployShip(playerFleet, playerMap)
  else
    print("Não foi possível enviar o navio ao mar!")
    os.execute("sleep 2")
  end
  os.execute("clear")
until playerFleetSize >= CFG.FLEET

initNpc()
os.execute("clear")
-- 1: Player, 2: Npc
local turn = 1

local function playerLoop(input)
  local coords = validateInput(input)

  if not coords then
    turn = 1
    print("Coordenada inválida!")
    os.execute("sleep 2")
    return
  end

  local validAttack = isValidCoords(coords, playerAttacks)
  if not validAttack then
    turn = 1
    print("Ataque já realizado!")
    os.execute("sleep 2")
    return
  end

  local hit = processAttack(coords, npcFleet, npcMap)
  table.insert(playerAttacks, coords)

  if not hit then
    turn = 2
    playerAttackMiss = playerAttackMiss + 1
    print("Splash! O ataque atingiu o mar.")
    print("Turno do inimigo!")
    os.execute("sleep 2")
    return
  end

  turn = 1
  playerAttackHits = playerAttackHits + 1
  print("Navio INIMIGO atingido!")
  print("Novo turno do jogador!")
  os.execute("sleep 2")
end

local function npcLoop()
  local idAttack = math.random(1, #npcValidAttacks)

  local hit = processAttack(npcValidAttacks[idAttack], playerFleet, playerMap)
  table.remove(npcValidAttacks, idAttack)
  npcAttacks = npcAttacks + 1

  if not hit then
    npcAttackMiss = npcAttackMiss + 1
    turn = 1
    return
  end

  turn = 2
  npcAttackHits = npcAttackHits + 1
  print("Navio ALIADO atingido!")
  print("Novo turno do inimigo!")
  os.execute('sleep 2')

end

repeat
  gameHUD()
  if turn == 1 then
    print("Turno do jogador, esperando coordenadas!")
    local input = io.read(2):upper()
    _ = io.stdin:read("*l")

    playerLoop(input)
  elseif turn == 2 then
    npcLoop()
  end

  if #playerFleet == 0 then npcWin = true end
  if #npcFleet == 0 then playerWin = true end
  os.execute("clear")
until playerWin or npcWin

print("Jogador:")
print("Frota: " .. #playerFleet .. "/" .. CFG.FLEET)
print("Acertos: " .. playerAttackHits .. "/" .. #playerAttacks)
print("Erros: " .. playerAttackMiss .. "/" .. #playerAttacks)
print("\nInimigo:")
print("Frota: " .. #npcFleet .. "/" .. CFG.FLEET)
print("Acertos: " .. npcAttackHits .. '/' .. npcAttacks)
print("Erros: " .. npcAttackMiss .. '/' .. npcAttacks)

if npcWin then
  print("\nO INIMIGO saiu vitorioso!")
  return
end

print("\nO JOGADOR saiu vitorioso!")
