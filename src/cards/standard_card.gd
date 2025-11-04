extends Resource
class_name StandardCard

@export var name: String = ""
@export_multiline var description: String = ""
@export var artwork: Texture2D
@export var type: String = "" # e.g., ADVENTURE, SPELL, ENEMY, OBJECT, FOLLOWER
@export var usable_in_combat: bool = false
@export var data: Dictionary = {}
@export var inventory_path: NodePath

func play(player) -> void:
	# Implement in subclasses
	pass

func can_be_played(player) -> bool:
	return true

func get_inventory(owner_node: Node) -> Node:
	if owner_node and inventory_path != NodePath("") and owner_node.has_node(inventory_path):
		return owner_node.get_node(inventory_path)
	return null