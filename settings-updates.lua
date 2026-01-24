local use_aai = data.raw["bool-setting"]["mdrn-use-aai-recipes"]
use_aai.forced_value = true
use_aai.hidden = true

if mods["Krastorio2"] then
  if mods["loaders-modernized-k2"] then
    local use_k2 = data.raw["bool-setting"]["mdrn-use-k2-recipes"]
    use_k2.forced_value = false
    use_k2.hidden = true
  end

  local unlock = data.raw["string-setting"]["mdrn-unlock-technology"]
  unlock.allowed_values = { "separate" }
  unlock.default_value = "separate"
  unlock.hidden = true
end