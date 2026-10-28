local playerHealth = 100
local playerDefense = 15

for i = 1, 5 do
  local enemyAttack = math.random(10, 30)
  local damage = enemyAttack - playerDefense

  if playerHealth <= 0 then
    break
  end

  print("Rodada: " .. i)

  if enemyAttack >= 20 then
    print("Ataque crítico!")
  end

  if damage > 0 then
    playerHealth = playerHealth - damage

    print("O player recebeu " .. damage .. " de dano!")
    print("Vida: " .. playerHealth)
  else
    print("O player desviou!")
    print("Vida: " .. playerHealth)
  end
end

if playerHealth <= 0 then
  print("O player NÃO sobreviveu ao combate!")
  return
end

print("O player sobreviveu ao combate com: " .. playerHealth .. " pontos de vida.")
