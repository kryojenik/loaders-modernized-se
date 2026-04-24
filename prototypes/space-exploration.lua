local utils = require("__space-exploration__.data_util")
local const = require("constants")
local C     = require("__loaders-modernized__.constants")
local cfg   = require("__loaders-modernized__.prototypes.settings-cache")
-- Define the loader template for the tier 5 turbo belt
local startup_settings = settings.startup

-- Space loader
---@type table<string, LMLoaderTemplate>
local loaders = {
  ["space-"] = {
    next_upgrade = "mdrn-deep-space-loader-black",
    underground_name = "se-space-underground-belt",
    order = "07",
    tint = util.color(const.colors.white.hex),
    prerequisite_techs = { "se-space-belt", "mdrn-fast-loader" },
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
    { type = "item", name = "mdrn-deep-space-loader-black", amount = 1 },
    { type = "item", name = "small-lamp", amount = 1 }
  }
}

for name, color in pairs(const.colors) do
  local color_enabled = startup_settings["se-deep-space-belt-" .. name]
  if name == "black" or (color_enabled and color_enabled.value) then
    loaders["deep-space-" .. name] = {
      underground_name = "se-deep-space-underground-belt-" .. name,
      name = "mdrn-deep-space-loader-" .. name,
      unlocked_by = cfg.unlock_technology == C.UNLOCK_TECH.BELT
        and "se-deep-space-transport-belt"
        or "mdrn-deep-space-loader",
      order = color.order,
      tint = util.color(color.hex),
      tech_tint = name == "black",
      dark_frame = true,
      prerequisite_techs = { "se-deep-space-transport-belt", "mdrn-space-loader" },
      recipe_data = name == "black" and rd_black or rd_color,
    }
  end
end

-- If using special stack or chute loaders with SE, clean up a few things
if cfg.stacking == C.STACKING.STACK_TIER
or cfg.chute_mode ~= C.CHUTE.NONE then
  data:extend{
    {
        type = "item-subgroup",
        name = "belt-loader-special",
        group = "logistics",
        order = "b[belt-loader2]"
    }
  }

  if cfg.stacking == C.STACKING.STACK_TIER then
    loaders["stack-"] = {
      tint = util.color("fc792fd1"),
      subgroup = "belt-loader-special",
      dark_frame = true
    }
  end

  if cfg.chute_mode ~= C.CHUTE.NONE then
    loaders["chute-"] = {
      tech_data = false,
      subgroup = "belt-loader-special",
    }
  end
end

MdrnLoaders.add_loaders(loaders)

-- Add science packs to techs to make them fit more thematically with Space Exploration
utils.tech_add_ingredients("mdrn-loader", {"logistic-science-pack"})
utils.tech_add_ingredients("mdrn-fast-loader", {"chemical-science-pack"})
utils.tech_add_ingredients("mdrn-space-loader", {"space-science-pack"})

-- Make sure our new SE loaders can be placed on space platforms
for tier, loader in pairs(loaders) do
  if tier ~= "chute-" then
    local name = loader.name or ("mdrn-" .. tier .. "loader")
    data.raw["loader-1x1"][name].se_allow_in_space = true
    data.raw["loader-1x1"][name .. "-split"].se_allow_in_space = true
    ---@diagnostic enable: inject-field
  end
end

-- You cannot upgrade from a land restricted loader to a space capable loader. Collision masks must match.
-- The stack loader is set to work on space platforms.  Perhaps there should be a separate land stack loader.
data.raw["loader-1x1"]["mdrn-express-loader"].next_upgrade = nil
data.raw["loader-1x1"]["mdrn-express-loader-split"].next_upgrade = nil
