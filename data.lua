--data.lua

--[[To work with boilers, input and output fluids need a heat_capacity property.
Fluid input/output rate is calculated as: energy_consumption / (heat_capacity * deltaTemp).]]
local fkcold = data.raw["fluid"]["fluoroketone-cold"]
fkcold.heat_capacity = settings.startup["fluoroketone_heat_capacity"].value
local fkhot = data.raw["fluid"]["fluoroketone-hot"]
fkhot.heat_capacity = settings.startup["fluoroketone_heat_capacity"].value

--[[Modify flamethrower turrets to accept fluoroketone-hot as ammo, and adjust other properties.]]
local flamethrowerturret = data.raw["fluid-turret"]["flamethrower-turret"]
flamethrowerturret.attack_parameters.damage_modifier = settings.startup["fluid-turret_damage_modifier"].value
flamethrowerturret.attack_parameters.fluid_consumption = settings.startup["fluid-turret_fluid_consumption"].value
--[[local add_fkhot_to_ft = {
    damage_modifier = 1.5,
    type = "fluoroketone-hot"
}
table.insert(flamethrowerturret.attack_parameters.fluids, add_fkhot_to_ft)]]
flamethrowerturret.attack_parameters.fluids = {
    {
        damage_modifier = settings.startup["crude-oil_damage_modifier"].value,
        type = "crude-oil"
    },
    {
        damage_modifier = settings.startup["heavy-oil_damage_modifier"].value,
        type = "heavy-oil"
    },
    {
        damage_modifier = settings.startup["light-oil_damage_modifier"].value,
        type = "light-oil"
    },
    {
        damage_modifier = settings.startup["fluoroketone-hot_damage_modifier"].value,
        type = "fluoroketone-hot"
    },
}

--[[Fluoroketone Boiler.]]
local og = data.raw["boiler"]["boiler"]
local ketoneboiler = table.deepcopy(og)
ketoneboiler.name = "ketone-".. og.name
ketoneboiler.minable.result = ketoneboiler.name
ketoneboiler.surface_conditions = nil
ketoneboiler.energy_consumption = settings.startup["ketone-boiler_energy_consumption"].value
ketoneboiler.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    drain = "0.3kW"
}
--input fluid
ketoneboiler.fluid_box.filter = "fluoroketone-cold"
ketoneboiler.fluid_box.minimum_temperature = -150
ketoneboiler.fluid_box.volume = settings.startup["ketone-boiler_fluid_box_volume"].value
--output fluid
ketoneboiler.mode = "output-to-separate-pipe"
ketoneboiler.output_fluid_box.filter = "fluoroketone-hot"
ketoneboiler.output_fluid_box.maximum_temperature = 180
ketoneboiler.output_fluid_box.volume = settings.startup["ketone-boiler_fluid_box_volume"].value
ketoneboiler.target_temperature = 180

--[[Fluoroketone Boiler Recipe.]]
local og_recipe = data.raw["recipe"]["boiler"]
local recipe = table.deepcopy(og_recipe)
recipe.name = ketoneboiler.name
recipe.results = {{type = "item", name = recipe.name, amount = 1}}
recipe.enabled = false --research unlock.
table.insert(data.raw["technology"]["cryogenic-plant"].effects, {type="unlock-recipe", recipe=ketoneboiler.name})

--[[Fluoroketone Boiler Item.]]
local og_item = data.raw["item"]["boiler"]
local item = table.deepcopy(og_item)
item.icons = {
    {
        icon = og_item.icon,
        icon_size = og_item.icon_size,
        tint = {r=0,g=0.3,b=0,a=0.3}
    },
}
item.name = ketoneboiler.name
item.place_result = ketoneboiler.name

data:extend{ketoneboiler, recipe, item}