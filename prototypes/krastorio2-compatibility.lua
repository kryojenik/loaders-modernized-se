local C = require("constants")
local util = require("__loaders-modernized__.scripts.utils")

if not mods["Krastorio2"] then
  return
end

local startup_settings = settings.startup

local move_to_aai = (mods["aai-loaders"] and startup_settings["aai-loaders-mode"].value ~= "graphics-only")
local pull_k2_to_mdrn = not move_to_aai and startup_settings["kr-loaders"].value

---@type table<string, LMLoaderTemplate>
local loaders = {
  [""] = {
    unlocked_by = move_to_aai and "aai-loader" or nil,
    recipe_data = {
      ingredients = {
        { type = "item", name = "iron-gear-wheel", amount = 10 },
        { type = "item", name = "electronic-circuit", amount = 5 },
        { type = "item", name = "transport-belt", amount = 1 }
      },
      stack_ingredients = {
        { type = "item", name = "iron-gear-wheel", amount = 20 },
        { type = "item", name = "electronic-circuit", amount = 10 },
        { type = "item", name = "transport-belt", amount = 1 }
      }
    },
  },
  ["fast-"] = {
    unlocked_by = move_to_aai and "aai-fast-loader" or nil,
    recipe_data = {
      ingredients = {
        { type = "item", name = "electric-motor", amount = 5 },
        { type = "item", name = "advanced-circuit", amount = 5 },
        { type = "item", name = "fast-transport-belt", amount = 1 },
        { type = "item", name = "mdrn-loader", amount = 1 },
      },
      stack_ingredients = {
        { type = "item", name = "electric-motor", amount = 10 },
        { type = "item", name = "advanced-circuit", amount = 10 },
        { type = "item", name = "fast-transport-belt", amount = 1 },
        { type = "item", name = "mdrn-loader", amount = 1 },
      }
    },
  },
  ["express-"] = {
    unlocked_by = move_to_aai and "aai-express-loader" or nil,
    recipe_data = {
      ingredients = {
        { type = "item", name = "electric-engine-unit", amount = 5 },
        { type = "item", name = "processing-unit", amount = 5 },
        { type = "item", name = "express-transport-belt", amount = 1 },
        { type = "item", name = "mdrn-fast-loader", amount = 1 },
      },
      stack_ingredients = {
        { type = "item", name = "electric-engine-unit", amount = 10 },
        { type = "item", name = "processing-unit", amount = 10 },
        { type = "item", name = "express-transport-belt", amount = 1 },
        { type = "item", name = "mdrn-fast-loader", amount = 1 },
      }
    },
  },
  ["advanced-"] = {
    unit = data.raw.technology["kr-logistic-4"] and data.raw.technology["kr-logistic-4"].unit,
    unlocked_by = move_to_aai and "aai-kr-advanced-loader" or nil,
    recipe_data = {
      ingredients = {
        { type = "item", name = "kr-imersium-gear-wheel", amount = 5 },
        { type = "item", name = "kr-rare-metals", amount = 5 },
        { type = "item", name = "kr-advanced-transport-belt", amount = 1 },
        { type = "item", name = "mdrn-express-loader", amount = 1 },
      },
      stack_ingredients = {
        { type = "item", name = "kr-imersium-gear-wheel", amount = 10 },
        { type = "item", name = "kr-rare-metals", amount = 10 },
        { type = "item", name = "kr-advanced-transport-belt", amount = 1 },
        { type = "item", name = "mdrn-express-loader", amount = 1 },
      }
    },
  },
  ["superior-"] = {
    unlocked_by = move_to_aai and "aai-kr-superior-loader" or nil,
    unit = data.raw.technology["kr-logistic-5"] and data.raw.technology["kr-logistic-5"].unit,
    recipe_data = {
      ingredients = {
        { type = "item", name = "kr-imersium-gear-wheel", amount = 5 },
        { type = "item", name = "se-heavy-bearing", amount = 5 },
        { type = "item", name = "kr-rare-metals", amount = 5 },
        { type = "item", name = "kr-superior-transport-belt", amount = 1 },
        { type = "item", name = "mdrn-advanced-loader", amount = 1 },
        { type = "item", name = "kr-imersium-plate", amount = 5 },
      },
      stack_ingredients = {
        { type = "item", name = "kr-imersium-gear-wheel", amount = 10 },
        { type = "item", name = "se-heavy-bearing", amount = 10 },
        { type = "item", name = "kr-rare-metals", amount = 10 },
        { type = "item", name = "kr-superior-transport-belt", amount = 1 },
        { type = "item", name = "mdrn-advanced-loader", amount = 1 },
        { type = "item", name = "kr-imersium-plate", amount = 10 },
      }
    },
  }
}

if move_to_aai then
  util.remove_recipe_from_effects("mdrn-space-loader")
  util.add_recipe_to_effects("aai-se-space-loader", "mdrn-space-loader")
  for color, _ in pairs(C.colors) do
    util.remove_recipe_from_effects("mdrn-deep-space-loader-" .. color)
    util.add_recipe_to_effects("aai-se-deep-space-loader", "mdrn-deep-space-loader-" .. color)
  end

elseif pull_k2_to_mdrn then
  local k2_loaders = {
    ["kr-loader"] = "mdrn-loader",
    ["kr-fast-loader"] = "mdrn-fast-loader",
    ["kr-express-loader"] = "mdrn-express-loader",
    ["kr-advanced-loader"] = "mdrn-advanced-loader",
    ["kr-superior-loader"] = "mdrn-superior-loader",
    ["kr-se-loader"] = "mdrn-space-loader",
    ["kr-se-deep-space-loader-black"] = "mdrn-deep-space-loader-black"
  }

  for k2_loader, unlocked_by in pairs(k2_loaders) do
    util.remove_recipe_from_effects(k2_loader)
    util.add_recipe_to_effects(unlocked_by, k2_loader)
  end
end

loaders["advanced-"].unit.time = 60
loaders["advanced-"].unit.count = 350
loaders["superior-"].unit.time = 60
loaders["superior-"].unit.count = 450

MdrnLoaders.add_loaders(loaders)
