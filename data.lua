--data.lua
--[[Fluoroketone.]]
--Fluid input/output rates for boiler entities are calculated as: energy_consumption / (heat_capacity * deltaTemp).]]
data.raw["fluid"]["fluoroketone-cold"].heat_capacity = settings.startup["fluoroketone_heat_capacity"].value
data.raw["fluid"]["fluoroketone-hot"].heat_capacity = settings.startup["fluoroketone_heat_capacity"].value

--[[Flamethrower Turret.]]
local flamethrowerturret = data.raw["fluid-turret"]["flamethrower-turret"]
flamethrowerturret.attack_parameters.damage_modifier = settings.startup["fluid-turret_damage_modifier"].value
flamethrowerturret.attack_parameters.fluid_consumption = settings.startup["fluid-turret_fluid_consumption"].value
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

--[[Electric Fluoroketone Boiler.]]
local elecelecKetoneBoiler = table.deepcopy(data.raw["boiler"]["boiler"])
elecKetoneBoiler.name = "elec-ketone-".. elecKetoneBoiler.name--elec-ketone-boiler
elecKetoneBoiler.minable.result = elecKetoneBoiler.name
elecKetoneBoiler.surface_conditions = nil
elecKetoneBoiler.energy_consumption = settings.startup["ketone-boiler_energy_consumption"].value
elecKetoneBoiler.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    drain = settings.startup["electric-ketone-boiler_energy_source_drain"].value
}
--input fluid
elecKetoneBoiler.fluid_box.filter = "fluoroketone-cold"
elecKetoneBoiler.fluid_box.minimum_temperature = -150
elecKetoneBoiler.fluid_box.volume = settings.startup["ketone-boiler_fluid_box_volume"].value
--output fluid
elecKetoneBoiler.mode = "output-to-separate-pipe"
elecKetoneBoiler.output_fluid_box.filter = "fluoroketone-hot"
elecKetoneBoiler.output_fluid_box.maximum_temperature = 180
elecKetoneBoiler.output_fluid_box.volume = settings.startup["ketone-boiler_fluid_box_volume"].value
elecKetoneBoiler.target_temperature = 180

local elecKetoneBoilerItem = table.deepcopy(data.raw["item"]["boiler"])
elecKetoneBoilerItem.icons = {
    {
        icon = elecKetoneBoilerItem.icon,
        icon_size = elecKetoneBoilerItem.icon_size,
        tint = {r=0,g=0.3,b=0,a=0.3}
    },
}
elecKetoneBoilerItem.name = elecKetoneBoiler.name
elecKetoneBoilerItem.place_result = elecKetoneBoilerItem.name

local elecKetoneBoilerRecipe = table.deepcopy(data.raw["recipe"]["boiler"])
elecKetoneBoilerRecipe.name = elecKetoneBoiler.name
elecKetoneBoilerRecipe.results = {{type = "item", name = elecKetoneBoilerRecipe.name, amount = 1}}
elecKetoneBoilerRecipe.enabled = false
table.insert(data.raw["technology"]["cryogenic-plant"].effects, {type="unlock-recipe", recipe=elecKetoneBoilerRecipe.name})

--[[Handheld Flamethrower Ammo.]]
local fkammoItem = table.deepcopy(data.raw["ammo"]["flamethrower-ammo"])
fkammoItem.name = "fluoro-".. fkammoItem.name
fkammoItem.icons = {
    {
        icon = fkammoItem.icon,
        icon_size = fkammoItem.icon_size,
        tint = {r=0,g=0.3,b=0,a=0.3}
    },
}
fkammoItem.order = fkammoItem.order.. "a"

local fkammoRecipe = table.deepcopy(data.raw["recipe"]["flamethrower-ammo"])
fkammoRecipe.name = fkammoItem.name
fkammoRecipe.ingredients = {
    {type="fluid", name="fluoroketone-hot", amount=20},
    {type="item", name="steel-plate", amount=5}
}
fkammoRecipe.results = {
    {type="item", name=fkammoRecipe.name, amount=1}
}
table.insert(data.raw["technology"]["cryogenic-plant"].effects, {type="unlock-recipe", recipe=fkammoRecipe.name})

--[[Fire Stream. Please see SPECIAL_THANKS.txt]]
local function entry_or_list(item,field,check,func,...)
	if item[field]==check then
		return func(item,...)
	else
		local result=false
		for _,e in pairs(item) do
			if e[field]==check then
				if func(e,...) then result=true end
			end
		end
		return result
	end
end

local function mul_damages(effect,dam)
	if effect.damage.type=="fire" then
		effect.damage.amount= effect.damage.amount*dam
		return true
	end
end

local function modify_effects(action,dam)
	if action.target_effects then return entry_or_list(action.target_effects, "type","damage", mul_damages, dam) end
end

local function modify_stream_action(action,size,dam)
	if action.action_delivery and entry_or_list(action.action_delivery, "type","instant", modify_effects, dam) then
		action.radius = action.radius * size
		return true
	end
end

local function modify_delivered_stream(del, size,dam)
	local sname = del.stream
	local stream = table.deepcopy(data.raw.stream[sname])
	sname = "fluoro-"..sname
	
	if stream.action and entry_or_list(stream.action,"type","area", modify_stream_action, size,dam) then
		stream.name = sname
		del.stream = sname
		data:extend{stream}
	end
end

local function modify_trigger(trig,size,dam)
	if trig.action_delivery then entry_or_list(trig.action_delivery,"type","stream", modify_delivered_stream ,size,dam) end
end

local function modify_ammo_type(ammotype,size,dam)
	if ammotype.action then entry_or_list(ammotype.action,"type","direct", modify_trigger, size,dam) end
end

local function create_mul_flammo(ammo,size,dam)
	entry_or_list(ammo.ammo_type,"category","flamethrower", modify_ammo_type ,size,dam)
end

local fkammoStreamSize = settings.startup["stream_size_modifier"].value
local fkammoStreamDamage = settings.startup["stream_damage_modifier"].value
create_mul_flammo(fkammoItem, fkammoStreamSize, fkammoStreamDamage)

data:extend{elecKetoneBoiler, elecKetoneBoilerItem, elecKetoneBoilerRecipe, fkammoItem, fkammoRecipe}