extends Node2D
class_name BoardManager

var regions: Array = [] # Array<Region>
var space_lookup := {}

func get_space_by_name(name: String):
	return space_lookup.get(name, null)

func get_adjacent_spaces(space) -> Array:
	# TODO: implement adjacency logic based on board layout
	return []

func get_starting_space(character_type: String):
	# TODO: map character type to starting space
	return null

func move_player_to_space(player: Node, space: Node) -> void:
	# TODO: update player position to space.world_position and trigger land events
	if space and "on_player_land" in space:
		space.on_player_land(player)