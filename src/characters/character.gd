extends Resource
class_name Character

@export var name: String = ""
@export var strength: int = 0
@export var craft: int = 0
@export var fate: int = 0
@export var lives: int = 4
@export var type: String = "" # WARRIOR, WIZARD, etc.
@export var portrait: Texture2D
@export_multiline var special_ability: String = ""

func use_special_ability(owner: Node = null) -> void:
	# Implement on concrete character resources
	pass

func modify_stat(stat: String, amount: int) -> void:
	match stat.to_lower():
		"strength": strength += amount
		"craft": craft += amount
		"fate": fate += amount
		"lives": lives += amount
		_: pass

func is_alive() -> bool:
	return lives > 0

func get_combat_score(is_psychic: bool) -> int:
	return craft if is_psychic else strength