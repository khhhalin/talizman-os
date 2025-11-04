extends StandardCard
class_name AdventureCard

@export var encounter_type: String = "" # e.g., ENEMY, STRANGER, PLACE, EVENT

func resolve_encounter(player: Node) -> void:
	# Implement encounter behavior
	pass