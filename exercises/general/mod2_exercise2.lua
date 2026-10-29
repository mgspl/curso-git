local craftRecipes = {
  {
    name = 'chair',
    ingredients = {
      { name = 'wood', count = 4 },
      { name = 'paint', count = 1 },
      { name = 'nail', count = 4 },
    },
  },
  {
    name = 'table',
    ingredients = {
      { name = 'wood', count = 8 },
      { name = 'paint', count = 1 },
      { name = 'nail', count = 4 },
    },
  },
  {
    name = 'halloween costume',
    ingredients = {
      { name = 'pumpkin', count = 1 },
      { name = 'cloth', count = 8 },
    },
  },
  {
    name = 'stone axe',
    ingredients = {
      { name = 'wood', count = 2 },
      { name = 'stone', count = 2 },
    },
  },
}

local craftsByIngredient = {}

function setupCraftsByIngredient()
  local recipes = getRecipes()
  for _, recipe in pairs(recipes) do
    for i = 1, #recipe.ingredients do
      local ingredient = recipe.ingredients[i].name
      if craftsByIngredient[ingredient] == nil then
        craftsByIngredient[ingredient] = {}
      end
      table.insert(craftsByIngredient[ingredient], recipe )
    end
  end
end

function getRecipes()
  return craftRecipes
end

function getRecipesByIngredientName(name)
  return craftsByIngredient[name] or {}
end

local function canCraft(recipe, inventory)
  for _, ingredient in ipairs(recipe.ingredients) do
    local available = inventory[ingredient.name]
    if not available or available < ingredient.count then
      return false
    end
  end
  return true
end

function getAvailableRecipes(ingredients)
  local seen = {}
  local result = {}
  local inventory = {}

  for _, item in ipairs(ingredients) do
    inventory[item.name] = item.count
    for _, recipe in ipairs(craftsByIngredient[item.name]) do
      if not seen[recipe.name] and canCraft(recipe, inventory) then
        seen[recipe.name] = true
        table.insert(result, recipe)
      end
    end
  end

  return result
end

function main()
  setupCraftsByIngredient()

  local ingredientName = getRecipesByIngredientName("wood")

  local avaliableRecipes = getAvailableRecipes({
    { name = 'wood', count = 5 },
    { name = 'nail', count = 4 },
    { name = 'paint', count = 30 },
  })

  for i = 1, #ingredientName do
    print(ingredientName[i].name)
  end

  print("---")

  for i = 1, #avaliableRecipes do
    print(avaliableRecipes[i].name)
  end
end

main()
