extends Area2D
class_name Space

@export var space_name: String = ""
@export var type: String = "" # CITY, VILLAGE, etc.
@export var world_position: Vector2
@export var inventory: NodePath

signal player_landed(player)
signal card_encountered(card, player)

func _ready():
	# Optional: ensure inventory node exists
	pass

func get_inventory_node() -> Node:
	return get_node(inventory) if inventory != NodePath("") and has_node(inventory) else null

func on_player_land(player: Node) -> void:
	player_landed.emit(player)
	# Optionally trigger encounters with cards placed on this space
	# ...

func on_player_leave(player: Node) -> void:
	# Cleanup or effects on leaving
	pass

func add_card(card: Resource) -> void:
	var inv = get_inventory_node()
	if inv and inv.has_method("add_card"):
		inv.add_card(card)

func remove_card(card: Resource) -> void:
	var inv = get_inventory_node()
	if inv and inv.has_method("remove_card"):
		inv.remove_card(card)