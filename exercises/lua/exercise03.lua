print("Para encerrar o programa utilize CTRL+C")
while true do
  local input = io.read()

  local email = input:gsub("%s+", ""):lower()

  if not email:match("@") then
    print("Email inválido!")
  else
    print("Email válido!")
    -- Aqui é at de @
    local atPosition = email:find("@")
    local user = string.sub(email, 1, atPosition - 1)
    local provider = string.sub(email, atPosition + 1, #email)
    print("Usuário: " .. user)
    print("Domínio: " .. provider)
    print("Email: ", email)
  end
end
