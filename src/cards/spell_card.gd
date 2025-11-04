extends StandardCard
class_name SpellCard

@export var craft_requirement: int = 0
@export var is_one_use: bool = true

func cast(player: Node, target: Node = null) -> void:
	# Implement spell effect
	pass