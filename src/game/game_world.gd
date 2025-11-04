extends Node2D
class_name GameWorld

@onready var board: Node = $Board if has_node("Board") else null
@onready var ui_manager: Node = $UI if has_node("UI") else null
var players: Array = []

func _ready():
	# Placeholder: setup when scene loads
	initialize_game()

func initialize_game() -> void:
	# TODO: use TurnManager/CardManager to set up a new game
	pass

func spawn_players() -> void:
	# TODO: instantiate player scenes and place them on starting spaces
	pass

func handle_player_movement() -> void:
	# TODO: movement handling integrated with networking
	pass