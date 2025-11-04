extends CharacterBody2D
class_name TalismanPlayer

@export var player_id: int = 0
@export var player_name: String = ""
@export var character: Resource # Character
@export var inventory_path: NodePath
@export var gold: int = 0
@export var current_space: NodePath
@export var state: String = "WAITING"
@export var synced_position: Vector2
@export var stunned: bool = false

func _ready():
	# Placeholder for wiring authority and inputs
	pass

func get_inventory() -> Node:
	return get_node(inventory_path) if inventory_path != NodePath("") and has_node(inventory_path) else null

func take_turn() -> void:
	# TODO: integrate with TurnManager
	pass

func roll_dice() -> int:
	# TODO: delegate to DiceRoller
	return 0

func move_to_space(space: Node) -> void:
	# TODO: board movement logic
	pass

func draw_card(deck_type: String):
	# TODO: CardManager draw
	return null

func encounter_card(card: Resource) -> void:
	# TODO: resolve encounter
	pass

@rpc("any_peer", "call_local")
func move_player(space_name: String) -> void:
	# TODO: server validate and move
	pass

@rpc("any_peer", "call_local")
func update_stats(stats: Dictionary) -> void:
	# TODO: apply stat updates
	pass