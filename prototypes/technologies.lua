data:extend({
	{
		type = "technology",
		name = "planet-discovery-sun",
		icon_size = 512,
		icons = PlanetsLib.technology_icon_constant_planet("__pelagos__/graphics/starmap-planet-pelagos.png", 512),
		essential = true,
		effects = {
			{
				type = "unlock-space-location",
				space_location = "sun",
				use_icon_overlay_constant = true,
			},
		},
		prerequisites = { "agricultural-science-pack", "fish-breeding" },
		unit = {
			count = 1000,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "chemical-science-pack", 1 },
				{ "space-science-pack", 1 },
				{ "agricultural-science-pack", 1 },
			},
			time = 60,
		},
		order = "ea[pelagos]",
	},
})
