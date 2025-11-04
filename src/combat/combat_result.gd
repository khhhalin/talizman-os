extends Resource
class_name CombatResult

@export var player_won: bool = false
@export var damage_dealt: int = 0
@export var consequences: Array[String] = []
@export var rewards: Dictionary = {}