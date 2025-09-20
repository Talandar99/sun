script.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface
	if surface.name ~= "sun" then
		return
	end

	local chunkpos = event.position
	local x = chunkpos.x * 32 + 16
	local y = chunkpos.y * 32 + 16

	local fancy_water = surface.create_entity({
		name = "sun-heat-shader",
		position = { x, y },
		create_build_effect_smoke = false,
	})

	if fancy_water then
		fancy_water.active = false
		fancy_water.destructible = false
		fancy_water.minable_flag = false
	end
end)
