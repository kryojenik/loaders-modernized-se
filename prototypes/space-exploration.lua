local utils = require("__space-exploration__.data_util")
local const = require("constants")
-- Define the loader template for the tier 5 turbo belt
local templates = {}
local startup_settings = settings.startup

-- Space loader
templates.loaders = {
  ["space-"] = {
    next_upgrade = "deep-space-mdrn-loader-black",
    underground_name = "se-space-underground-belt",
    order = "07",
    tint = util.color(const.colors.white.hex),
    prerequisite_techs = { "se-space-belt", "fast-mdrn-loader" },
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

for name, color in pairs(const.colors) do
  local color_enabled = startup_settings["se-deep-space-belt-" .. name]
  if name == "black" or (color_enabled and color_enabled.value) then
    templates.loaders["deep-space-" .. name] = {
      underground_name = "se-deep-space-underground-belt-" .. name,
      name = "deep-space-mdrn-loader-" .. name,
      unlocked_by = startup_settings["mdrn-unlock-technology"].value == "belt"
        and "se-deep-space-transport-belt"
        or "deep-space-mdrn-loader",
      order = color.order,
      tint = util.color(color.hex),
      no_tech_tint = name ~= "black",
      dark_frame = true,
      prerequisite_techs = { "se-deep-space-transport-belt", "space-mdrn-loader" },
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

-- Add science packs to techs to make them fit more thematically with Space Exploration
utils.tech_add_ingredients("mdrn-loader", {"logistic-science-pack"})
utils.tech_add_ingredients("fast-mdrn-loader", {"chemical-science-pack"})
utils.tech_add_ingredients("space-mdrn-loader", {"space-science-pack"})

-- Make sure our new SE loaders can be placed on space platforms
for prefix, loader in pairs(templates.loaders) do
  if prefix ~= "chute-" then
    local name = loader.name or (prefix .. "mdrn-loader")
    ---@diagnostic disable: inject-field
    data.raw["loader-1x1"][name].se_allow_in_space = true
    data.raw["loader-1x1"][name .. "-split"].se_allow_in_space = true
    ---@diagnostic enable: inject-field
  end
end

-- You cannot upgrade from a land restricted loader to a space capable loader. Collision masks must match.
-- The stack loader is set to work on space platforms.  Perhaps there should be a separate land stack loader.
data.raw["loader-1x1"]["express-mdrn-loader"].next_upgrade = nil
data.raw["loader-1x1"]["express-mdrn-loader-split"].next_upgrade = nil
