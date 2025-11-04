extends Node
class_name DiceRoller

var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func roll_die() -> int:
	return rng.randi_range(1, 6)

func roll_multiple(count: int) -> Array[int]:
	var results: Array[int] = []
	for i in range(count):
		results.append(roll_die())
	return results

func roll_with_fate(base_roll: int, fate_tokens: int) -> int:
	# Placeholder: allow rerolls or modifiers based on fate
	return max(base_roll, roll_die())