-- Define the loader template for the tier 5 turbo belt
local templates = {}
local startup_settings = settings.startup

-- Colors for deep-space loaders
local colors = {
  black = { hex = "000000d1", order = "08" },
  blue = { hex = "0000ffd1", order = "09" },
  cyan = { hex = "00ffffd1", order = "10" },
  green = { hex = "00ff00d1", order = "11" },
  magenta = { hex = "ff00ffd1", order = "12" },
  red = { hex = "ff0000d1", order = "13" },
  white = { hex = "ffffffd1", order = "14" },
  yellow = { hex = "ffff00d1", order = "15" },
}

local space_tech = data.raw["technology"]["aai-se-space-loader"] and "se-space-mdrn-loader" or "space-mdrn-loader"
local deep_space_tech = data.raw["technology"]["aai-se-deep-space-loader"] and "se-deep-space-mdrn-loader" or "deep-space-mdrn-loader"
local fast_tech = data.raw["technology"]["aai-fast-loader"] and "aai-fast-loader" or "fast-mdrn-loader"

-- Space loader
templates.loaders = {
  ["space-"] = {
    next_upgrade = "deep-space-mdrn-loader-black",
    underground_name = "se-space-underground-belt",
    order = "07",
    tint = util.color(colors.white.hex),
    unlocked_by = startup_settings["mdrn-unlock-technology"].value == "belt"
      and "se-space-transport-belt"
      or space_tech,
    prerequisite_techs = { "se-space-belt", fast_tech },
    recipe_data = {
      ingredients = {
        { type = "item", name = "se-space-transport-belt", amount = 1 },
        { type = "item", name = "low-density-structure", amount = 5 },
        { type = "item", name = "electric-engine-unit", amount = 5 },
        { type = "item", name = "processing-unit", amount = 5 }
      },
      stack_ingredients = {
        { type = "item", name = "se-space-transport-belt", amount = 1 },
        { type = "item", name = "low-density-structure", amount = 10 },
        { type = "item", name = "electric-engine-unit", amount = 10 },
        { type = "item", name = "processing-unit", amount = 10 }
      }
    },
  },
}

-- Deep space loaders
local rd_black = {
  ingredients = {
    { type = "item", name = "se-deep-space-transport-belt-black", amount = 1 },
    { type = "item", name = "se-nanomaterial", amount = 5 },
    { type = "item", name = "se-heavy-assembly", amount = 5 },
    { type = "item", name = "se-quantum-processor", amount = 1 },
    { type = "item", name = "se-naquium-cube", amount = 1 },
  },
  stack_ingredients = {
    { type = "item", name = "se-deep-space-transport-belt-black", amount = 1 },
    { type = "item", name = "se-nanomaterial", amount = 10 },
    { type = "item", name = "se-heavy-assembly", amount = 10 },
    { type = "item", name = "se-quantum-processor", amount = 1 },
    { type = "item", name = "se-naquium-cube", amount = 2 },
  },
}
local rd_color = {
  ingredients = {
    { type = "item", name = "deep-space-mdrn-loader-black", amount = 1 },
    { type = "item", name = "small-lamp", amount = 1 }
  }
}

for name, color in pairs(colors) do
  local color_enabled = startup_settings["se-deep-space-belt-" .. name]
  if name == "black" or (color_enabled and color_enabled.value) then
    templates.loaders["deep-space-" .. name] = {
      underground_name = "se-deep-space-underground-belt-" .. name,
      name = "deep-space-mdrn-loader-" .. name,
      unlocked_by = startup_settings["mdrn-unlock-technology"].value == "belt"
        and "se-deep-space-transport-belt"
        or deep_space_tech,
      order = color.order,
      tint = util.color(color.hex),
      dark_frame = true,
      prerequisite_techs = { "se-deep-space-transport-belt", space_tech },
      recipe_data = name == "black" and rd_black or rd_color,
    }
  end
end

-- If using special stack or chute loaders with SE, clean up a few things
if startup_settings["mdrn-enable-stacking"].value == "stack-tier"
or startup_settings["mdrn-enable-chute"].value then
  data:extend{
    {
        type = "item-subgroup",
        name = "belt-loader-special",
        group = "logistics",
        order = "b[belt-loader2]"
    }
  }

  if startup_settings["mdrn-enable-stacking"].value == "stack-tier" then
    templates.loaders["stack-"] = {
      tint = util.color("fc792fd1"),
      subgroup = "belt-loader-special",
      dark_frame = true
    }
  end

  if startup_settings["mdrn-enable-chute"].value then
    templates.loaders["chute-"] = {
      no_tech = true,
      subgroup = "belt-loader-special",
    }
  end
end

MdrnLoaders.make_modern_loaders(templates)

-- Make sure our new SE loaders can be placed on space platforms
for prefix, loader in pairs(templates.loaders) do
  if prefix ~= "chute-" then
    local name = loader.name or (prefix .. "mdrn-loader")
    ---@diagnostic disable-next-line: inject-field
    data.raw["loader-1x1"][name].se_allow_in_space = true
    ---@diagnostic disable-next-line: inject-field
    data.raw["loader-1x1"][name .. "-split"].se_allow_in_space = true
  end
end






if mods["Krastorio2"] then
  templates.loaders = {
    [""] = {
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
      recipe_data = {
        ingredients = {
          { type = "item", name = "electric-engine-unit", amount = 5 },
          { type = "item", name = "processing-unit", amount = 5 },
          { type = "item", name = "express-transport-belt", amount = 1 },
          { type = "item", name = "fast-mdrn-loader", amount = 1 },
        },
        stack_ingredients = {
          { type = "item", name = "electric-engine-unit", amount = 10 },
          { type = "item", name = "processing-unit", amount = 10 },
          { type = "item", name = "express-transport-belt", amount = 1 },
          { type = "item", name = "fast-mdrn-loader", amount = 1 },
        }
      },
    },
    ["advanced-"] = {
      recipe_data = {
        ingredients = {
          { type = "item", name = "kr-imersium-gear-wheel", amount = 5 },
          { type = "item", name = "kr-rare-metals", amount = 5 },
          { type = "item", name = "kr-advanced-transport-belt", amount = 1 },
          { type = "item", name = "express-mdrn-loader", amount = 1 },
        },
        stack_ingredients = {
          { type = "item", name = "kr-imersium-gear-wheel", amount = 10 },
          { type = "item", name = "kr-rare-metals", amount = 10 },
          { type = "item", name = "kr-advanced-transport-belt", amount = 1 },
          { type = "item", name = "express-mdrn-loader", amount = 1 },
        }
      },
    },
    ["superior-"] = {
      recipe_data = {
        ingredients = {
          { type = "item", name = "kr-imersium-gear-wheel", amount = 5 },
          { type = "item", name = "se-heavy-bearing", amount = 5 },
          { type = "item", name = "kr-rare-metals", amount = 5 },
          { type = "item", name = "kr-superior-transport-belt", amount = 1 },
          { type = "item", name = "advanced-mdrn-loader", amount = 1 },
          { type = "item", name = "kr-imersium-plate", amount = 5 },
        },
        stack_ingredients = {
          { type = "item", name = "kr-imersium-gear-wheel", amount = 10 },
          { type = "item", name = "se-heavy-bearing", amount = 10 },
          { type = "item", name = "kr-rare-metals", amount = 10 },
          { type = "item", name = "kr-superior-transport-belt", amount = 1 },
          { type = "item", name = "advanced-mdrn-loader", amount = 1 },
          { type = "item", name = "kr-imersium-plate", amount = 10 },
        }
      },
    }
  }
  MdrnLoaders.make_modern_loaders(templates)
end


-- You cannot upgrade from a land restricted loader to a space capable loader. Collision masks must match.
-- The stack loader is set to work on space platforms.  Perhaps there should be a separate land stack loader.
data.raw["loader-1x1"]["express-mdrn-loader"].next_upgrade = nil
data.raw["loader-1x1"]["express-mdrn-loader-split"].next_upgrade = nil
