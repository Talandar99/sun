local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")
local effects = require("__core__.lualib.surface-render-parameter-effects")
local tile_sounds = require("__base__/prototypes/tile/tile-sounds")
local decorative_trigger_effects = require("__base__/prototypes/decorative/decorative-trigger-effects")
local base_decorative_sprite_priority = "extra-high"
local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

local function MapGen_Sun()
	local map = {
		aux_climate_control = false,
		moisture_climate_control = false,
		property_expression_names = {
			--elevation = "pelagos_elevation",
			--aux = "nauvis_aux",
			--["entity:pelagos-iron-ore:probability"] = "pelagos_iron_ore_probability",
			--["entity:pelagos-iron-ore:richness"] = "pelagos_iron_ore_richness",
		},
		cliff_settings = nil,
		default_enable_all_autoplace_controls = false,
		autoplace_controls = {},
		autoplace_settings = {
			["tile"] = {
				settings = {
					["sun-surface"] = {
						frequency = 1,
						size = 1,
						richness = 1,
					},
				},
			},
			["decorative"] = {},
			["entity"] = {},
		},
		--terrain_segmentation = "very-high",
		default_tile = "sun-surface",
	}
	return map
end
--sun definition
PlanetsLib:extend({
	{
		type = "planet",
		name = "sun",
		label_orientation = 0.15,
		orbit = {
			parent = { type = "space-location", name = "star" },
			distance = 0,
			orientation = 0.11,
		},
		subgroup = "planets",
		icon = "__sun__/graphics/starmap-star.png",
		icon_size = 512,
		starmap_icon = "__sun__/graphics/starmap-star.png",
		starmap_icon_size = 512,
		map_gen_settings = MapGen_Sun(),
		draw_orbit = true,
		--magnitude = 1.1,
		magnitude = 10,
		gravity_pull = 10,
		pollutant_type = "electromagnetic_waves",
		--pollutant_type = nil
		order = "a[pelagos]",
		surface_properties = {
			-- There is no stat for robot energy usage, it's (gravity/pressure) * 100x
			--["day-night-cycle"] = 10 * minute,
			["magnetic-field"] = 50,
			["solar-power"] = 50,
			pressure = 1500,
			gravity = 15,
		},

		surface_render_parameters = {
			--clouds = effects.default_clouds_effect_properties(),
			persistent_ambient_sounds = {
				base_ambience = { filename = "__base__/sound/world/world_base_wind.ogg", volume = 0.3 },
				wind = { filename = "__base__/sound/wind/wind.ogg", volume = 0.8 },
				crossfade = {
					order = { "wind", "base_ambience" },
					curve_type = "cosine",
					from = { control = 0.35, volume_percentage = 0.0 },
					to = { control = 2, volume_percentage = 100.0 },
				},
			},
			-- Should be based on the default day/night times, ie
			-- sun starts to set at 0.25
			-- sun fully set at 0.45
			-- sun starts to rise at 0.55
			-- sun fully risen at 0.75
			day_night_cycle_color_lookup = {
				{ 0.00, "__sun__/graphics/sun-day.png" },
				--{ 0.00, "__sun__/graphics/sun-night.png" },
				--{ 0.00, "__space-age__/graphics/lut/vulcanus-2-night.png" },
				--{ 0.15, "__space-age__/graphics/lut/gleba-2-afternoon.png" },
				--{ 0.25, "__space-age__/graphics/lut/gleba-3-late-afternoon.png" },
				--{ 0.35, "__space-age__/graphics/lut/gleba-4-sunset.png" },
				--{ 0.45, "__space-age__/graphics/lut/gleba-5-after-sunset.png" },
				--{ 0.55, "__space-age__/graphics/lut/gleba-6-before-dawn.png" },
				--{ 0.65, "__space-age__/graphics/lut/gleba-7-dawn.png" },
				--{ 0.75, "__space-age__/graphics/lut/gleba-8-morning.png" },
			},
		},
		solar_power_in_space = 200,
		platform_procession_set = {
			arrival = { "planet-to-platform-b" },
			departure = { "platform-to-planet-a" },
		},
		planet_procession_set = {
			arrival = { "platform-to-planet-b" },
			departure = { "planet-to-platform-a" },
		},
		--procession_graphic_catalogue = planet_catalogue_pelagos,
		asteroid_spawn_influence = 1,
		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_gleba, 0.9),
	},
	is_planet = true,
})
data:extend({
	{
		type = "space-connection",
		name = "vulcanus-sun",
		subgroup = "planet-connections",
		from = "vulcanus",
		to = "sun",
		order = "d",
		length = 15,
		asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.gleba_fulgora),
	},
})
