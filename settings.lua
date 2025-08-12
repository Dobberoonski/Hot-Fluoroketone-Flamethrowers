--settings.lua
data:extend({
    {
        --x0.5 flame damage from vanilla
        type = "double-setting",
        name = "fluid-turret_damage_modifier",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 0.5,
        order = "ponya"
    },
    {
        --x10 fluid cost from vanilla
        type = "double-setting",
        name = "fluid-turret_fluid_consumption",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 2,
        order = "ponyb"
    },
    {
        --vanilla setting
        type = "double-setting",
        name = "crude-oil_damage_modifier",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 1,
        order = "ponyc"
    },
    {
        --vanilla setting
        type = "double-setting",
        name = "heavy-oil_damage_modifier",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 1.05,
        order = "ponyd"
    },
    {
        --vanilla setting
        type = "double-setting",
        name = "light-oil_damage_modifier",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 1.1000000000000001,--don't know why it's like this
        order = "ponye"
    },
    {
        --incentivize fk use by bringing it near vanilla light oil damage levels
        type = "double-setting",
        name = "fluoroketone-hot_damage_modifier",
        setting_type = "startup",
        minimum_value = 0,
        default_value = 2.2000000000000001,--but i ain't gonna question it lol
        order = "ponyf"
    },
    {
        type = "string-setting",
        name = "ketone-boiler_energy_consumption",
        setting_type = "startup",
        default_value = "1kW",
        allow_blank = false,
        auto_trim = true,
        order = "ponyg"
    },
    {
        type = "string-setting",
        name = "electric-ketone-boiler_energy_source_drain",
        setting_type = "startup",
        default_value = "300W",
        allow_blank = false,
        auto_trim = true,
        order = "ponyh"
    }
    {
        type = "string-setting",
        name = "fluoroketone_heat_capacity",
        setting_type = "startup",
        default_value = "3J",
        allow_blank = false,
        auto_trim = true,
        order = "ponyi"
    },
    {
        --x0.5 fluid volume from vanilla
        type = "double-setting",
        name = "ketone-boiler_fluid_box_volume",
        setting_type = "startup",
        minimum_value = 1,
        default_value = 100,
        order = "ponyj"
    },
    {
        type = "double-setting",
        name = "stream_size_modifier",
        setting_type = "startup",
        minimum_value = 1,
        default_value = 1.3,
        order = "ponyk"
    },
    {
        type = "double-setting",
        name = "stream_damage_modifier",
        setting_type = "startup",
        minimum_value = 1,
        default_value = 2.7,
        order = "ponyl"
    },
})