extends StandardCard
class_name EnemyCard

@export var strength: int = 0
@export var craft: int = 0
@export var is_psychic: bool = false
@export var special_rules: Array[String] = []

func initiate_combat(player: Node):
	# Integrate with CombatManager later
	return null