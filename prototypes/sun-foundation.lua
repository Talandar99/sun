local sounds = require("__base__.prototypes.entity.sounds")
local space_age_sounds = require("__space-age__.prototypes.entity.sounds")
local item_sounds = require("__base__.prototypes.item_sounds")
local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")
local item_tints = require("__base__.prototypes.item-tints")
local item_effects = require("__space-age__.prototypes.item-effects")
local meld = require("meld")
local simulations = require("__space-age__.prototypes.factoriopedia-simulations")
local tile_trigger_effects = require("__space-age__/prototypes/tile/tile-trigger-effects")
local tile_pollution = require("__space-age__/prototypes/tile/tile-pollution-values")
local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")

local space_platform_tile_animations = require("__space-age__/prototypes/tile/platform-tile-animations")

local base_sounds = require("__base__/prototypes/entity/sounds")
local base_tile_sounds = require("__base__/prototypes/tile/tile-sounds")
local space_age_tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local patch_for_inner_corner_of_transition_between_transition =
	tile_graphics.patch_for_inner_corner_of_transition_between_transition

table.insert(out_of_map_tile_type_names, "empty-space")
table.insert(water_tile_type_names, "oil-ocean-shallow")
table.insert(water_tile_type_names, "oil-ocean-deep")
lava_tile_type_names = lava_tile_type_names or {}

space_age_tiles_util = space_age_tiles_util or {}

default_transition_group_id = default_transition_group_id or 0
water_transition_group_id = water_transition_group_id or 1
out_of_map_transition_group_id = out_of_map_transition_group_id or 2
lava_transition_group_id = lava_transition_group_id or 3
local foundation_proto = data.raw.tile["foundation"]
local foundation_transitions = foundation_proto and table.deepcopy(foundation_proto.transitions) or {}
local foundation_tbt = foundation_proto and table.deepcopy(foundation_proto.transitions_between_transitions) or {}
local foundation_neighbors = foundation_proto and table.deepcopy(foundation_proto.allowed_neighbors) or {}

local foundation_transitions = {
	{
		to_tiles = water_tile_type_names,
		transition_group = water_transition_group_id,

		spritesheet = "__sun__/graphics/foundation.png",
		layout = tile_spritesheet_layout.transition_8_8_8_4_4,
		background_enabled = false,
		effect_map_layout = {
			spritesheet = "__base__/graphics/terrain/effect-maps/water-stone-mask.png",
			inner_corner_count = 1,
			outer_corner_count = 1,
			side_count = 1,
			u_transition_count = 1,
			o_transition_count = 1,
			tile_height = 2,
		},
	},
	concrete_to_out_of_map_transition,
}

local foundation_transitions_between_transitions = {
	{
		transition_group1 = default_transition_group_id,
		transition_group2 = water_transition_group_id,

		spritesheet = "__space-age__/graphics/terrain/water-transitions/foundation-transitions.png",
		layout = tile_spritesheet_layout.transition_3_3_3_1_0,
		background_enabled = false,
		effect_map_layout = {
			spritesheet = "__base__/graphics/terrain/effect-maps/water-stone-to-land-mask.png",
			o_transition_count = 0,
		},
	},
	{
		transition_group1 = default_transition_group_id,
		transition_group2 = out_of_map_transition_group_id,

		background_layer_offset = 1,
		background_layer_group = "zero",
		offset_background_layer_by_tile_layer = true,

		spritesheet = "__base__/graphics/terrain/out-of-map-transition/concrete-out-of-map-transition-b.png",
		layout = tile_spritesheet_layout.transition_3_3_3_1_0,
	},
	{
		transition_group1 = water_transition_group_id,
		transition_group2 = out_of_map_transition_group_id,

		background_layer_offset = 1,
		background_layer_group = "zero",
		offset_background_layer_by_tile_layer = true,

		spritesheet = "__base__/graphics/terrain/out-of-map-transition/concrete-shore-out-of-map-transition.png",
		layout = tile_spritesheet_layout.transition_3_3_3_1_0,
		effect_map_layout = {
			spritesheet = "__base__/graphics/terrain/effect-maps/water-stone-to-out-of-map-mask.png",
			u_transition_count = 0,
			o_transition_count = 0,
		},
	},
}
allowed_neighbors = foundation_neighbors
local grass_vehicle_speed_modifier = 1.6
local dirt_vehicle_speed_modifier = 1.4
local sand_vehicle_speed_modifier = 1.8
local stone_path_vehicle_speed_modifier = 1.1
local concrete_vehicle_speed_modifier = 0.8

-- An 'infinity-like' number used to give water an elevation range that
-- is effectively unbounded on the low end
local water_inflike = 4096
data:extend({
	{
		type = "item",
		name = "sun-foundation",
		icon = "__space-age__/graphics/icons/foundation.png",
		subgroup = "terrain",
		order = "c[landfill]-g[foundation]",
		inventory_move_sound = item_sounds.metal_large_inventory_move,
		pick_sound = item_sounds.metal_large_inventory_pickup,
		drop_sound = item_sounds.metal_large_inventory_move,
		stack_size = 50,
		default_import_location = "aquilo",
		weight = 20 * kg,
		place_as_tile = {
			result = "sun-foundation",
			condition_size = 1,
			condition = { layers = {} },
			tile_condition = {
				"sun-surface",
			},
		},
	},
	{
		type = "tile",
		name = "sun-foundation",
		order = "a[artificial]-f",
		subgroup = "artificial-tiles",
		needs_correction = false,
		minable = { mining_time = 0.5, result = "sun-foundation" },
		mined_sound = base_sounds.deconstruct_bricks(0.8),
		is_foundation = true,
		collision_mask = tile_collision_masks.ground(),
		layer = 9,
		layer_group = "ground-artificial",
		transition_overlay_layer_offset = 2, -- need to render border overlay on top of hazard-concrete
		decorative_removal_probability = 0.25,
		variants = {
			main = {
				{
					picture = "__space-age__/graphics/terrain/space-platform/space-platform-1x1.png",
					count = 16,
					size = 1,
					scale = 0.5,
				},
				{
					picture = "__space-age__/graphics/terrain/space-platform/space-platform-2x2.png",
					count = 16,
					size = 2,
					probability = 0.75,
					scale = 0.5,
				},
			},
			transition = {
				overlay_layout = {
					inner_corner = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-inner-corner.png",
						count = 16,
						scale = 0.5,
					},
					outer_corner = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-outer-corner.png",
						count = 8,
						scale = 0.5,
					},
					side = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-side.png",
						count = 16,
						scale = 0.5,
					},
					u_transition = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-u.png",
						count = 8,
						scale = 0.5,
					},
					o_transition = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-o.png",
						count = 4,
						scale = 0.5,
					},
				},
				mask_layout = {
					inner_corner = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-inner-corner-mask.png",
						count = 16,
						scale = 0.5,
					},
					outer_corner = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-outer-corner-mask.png",
						count = 8,
						scale = 0.5,
					},
					side = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-side-mask.png",
						count = 16,
						scale = 0.5,
					},
					u_transition = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-u-mask.png",
						count = 8,
						scale = 0.5,
					},
					o_transition = {
						spritesheet = "__space-age__/graphics/terrain/foundation/foundation-o-mask.png",
						count = 4,
						scale = 0.5,
					},
				},
			},
		},
		transitions = foundation_transitions,
		transitions_between_transitions = foundation_transitions_between_transitions,

		walking_sound = base_tile_sounds.walking.dirt,
		build_sound = base_tile_sounds.building.concrete,
		map_color = { 57, 39, 26 },
		scorch_mark_color = { r = 0.329, g = 0.242, b = 0.177, a = 1.000 },
		vehicle_friction_modifier = 1.1,

		trigger_effect = tile_trigger_effects.concrete_trigger_effect(),
	},
})
