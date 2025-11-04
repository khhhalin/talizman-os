extends Resource
class_name Effect

@export var name: String = ""
@export_multiline var description: String = ""
@export var duration: String = "INSTANT" # INSTANT, ONE_TURN, PERMANENT, CONDITIONAL

func apply(player: Node) -> void:
	pass

func remove(player: Node) -> void:
	pass