local tile_trigger_effects = require("__space-age__/prototypes/tile/tile-trigger-effects")
local tile_pollution = require("__space-age__/prototypes/tile/tile-pollution-values")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local base_tile_sounds = require("__base__/prototypes/tile/tile-sounds")
local tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local lava_to_out_of_map_transition = {
	to_tiles = out_of_map_tile_type_names,
	transition_group = out_of_map_transition_group_id,

	overlay_layer_group = "zero",
	apply_effect_color_to_overlay = true,
	background_layer_offset = 1,
	background_layer_group = "zero",
	offset_background_layer_by_tile_layer = true,

	spritesheet = "__base__/graphics/terrain/out-of-map-transition/water-out-of-map-transition-tintable.png",
	layout = tile_spritesheet_layout.transition_4_4_8_1_1,
	background_enabled = false,

	apply_waving_effect_on_masks = true,
	waving_effect_time_scale = 0.005,
	mask_layout = {
		spritesheet = "__base__/graphics/terrain/masks/water-edge-transition.png",
		count = 1,
		double_side_count = 0,
		scale = 0.5,
		outer_corner_x = 64,
		side_x = 128,
		u_transition_x = 192,
		o_transition_x = 256,
		y = 0,
	},
}
data:extend({
	{
		type = "tile",
		--name = "lava-hot",
		name = "sun-surface",
		order = "a-a",
		subgroup = "vulcanus-tiles",
		collision_mask = tile_collision_masks.lava(),
		autoplace = {
			probability_expression = "max(lava_hot_basalts_range, lava_hot_mountains_range)",
		},
		effect = "lava",
		fluid = "lava",
		effect_color = { 167, 59, 27 },
		effect_color_secondary = { 49, 80, 14 },
		particle_tints = tile_graphics.lava_particle_tints,
		destroys_dropped_items = true,
		default_destroyed_dropped_item_trigger = destroyed_item_trigger,
		layer = 5,
		layer_group = "water",
		--sprite_usage_surface = "sun",
		variants = {
			main = {
				{
					picture = "__space-age__/graphics/terrain/vulcanus/lava-hot.png",
					count = 1,
					scale = 1,
					--scale = 0.5,
					size = 1,
				},
			},
			empty_transitions = true,
		},
		allowed_neighbors = { "lava" },
		transitions = { lava_to_out_of_map_transition },
		transitions_between_transitions = data.raw.tile["water"].transitions_between_transitions,
		map_color = { r = 255, g = 138, b = 57 },
		absorptions_per_second = tile_pollution.lava,
		default_cover_tile = "sun-foundation",
		ambient_sounds = tile_sounds.ambient.magma,
	},
})

-- allow foundation on sun-surface
local landfill = data.raw.item["sun-foundation"]
if landfill and landfill.place_as_tile and landfill.place_as_tile.tile_condition then
	table.insert(landfill.place_as_tile.tile_condition, "sun-surface")
end
-- make sun-surface water tile
table.insert(water_tile_type_names, "sun-surface")
