extends Node
class_name CombatManager

signal combat_started(attacker, defender)
signal combat_resolved(result)

var is_psychic_combat: bool = false
var attacker: Node = null
var defender: Node = null

func initiate_combat(p_attacker: Node, p_defender: Node, is_psychic: bool) -> void:
	is_psychic_combat = is_psychic
	attacker = p_attacker
	defender = p_defender
	combat_started.emit(attacker, defender)
	# ...roll dice or compute immediately...
	# Call resolve_combat() when ready

func resolve_combat():
	# TODO: compute CombatResult and emit
	var result := CombatResult.new()
	combat_resolved.emit(result)
	return result

func calculate_combat_score(player: Node) -> int:
	# TODO: compute based on stats and items
	return 0