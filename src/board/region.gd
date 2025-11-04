extends Area2D
class_name Region

@export var region_name: String = ""
@export var type: String = "" # OUTER_REGION, MIDDLE_REGION, etc.
var spaces: Array = [] # Array<Space>

func get_spaces() -> Array:
	return spaces

func is_accessible_to(player: Node) -> bool:
	# TODO: logic to determine access by player state
	return true