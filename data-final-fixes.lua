-- data-final-fixes.lua
data.raw.tile["sun_foundation"] = nil
local platform = data.raw.tile["space-platform"]
if platform then
	local sun_foundation = table.deepcopy(platform)

	sun_foundation.name = "sun-foundation"

	sun_foundation.order = "a[artificial]-sun"
	sun_foundation.map_color = { r = 200, g = 120, b = 50 } -- pomarańcz na mapie
	if sun_foundation.minable then
		sun_foundation.minable.result = "sun-foundation"
	end

	data:extend({ sun_foundation })
end

data:extend({
	{
		type = "item",
		name = "sun-foundation",
		icon = "__space-age__/graphics/icons/foundation.png",
		icon_size = 64,
		subgroup = "terrain",
		order = "c[landfill]-g[sun-foundation]",
		stack_size = 50,
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
})
