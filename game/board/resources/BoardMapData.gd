@tool
class_name BoardMapData
extends Resource

## A Godot Resource to replace JSON-based map data.
## This provides type safety and editor integration.

@export var nodes: Array[NodeData] = []
@export var edges: Array[EdgeData] = []

class NodeData:
	extends Resource
	@export var id: String = ""
	@export var x: int = 0
	@export var y: int = 0
	@export var tile_type: String = "rest"
	@export var custom_scene: PackedScene = null
	
class EdgeData:
	extends Resource
	@export var from: String = ""
	@export var to: String = ""
	@export var directed: bool = false

func get_node_by_id(node_id: String) -> NodeData:
	for n in nodes:
		if n.id == node_id:
			return n
	return null

func validate() -> Array:
	var errors: Array = []
	var ids := {}
	
	# Check unique IDs
	for n in nodes:
		if n.id == "":
			errors.append("Node with empty ID")
			continue
		if ids.has(n.id):
			errors.append("Duplicate node ID: " + n.id)
		ids[n.id] = true
	
	# Validate edges reference existing nodes
	for e in edges:
		if not ids.has(e.from):
			errors.append("Edge references unknown node: " + e.from)
		if not ids.has(e.to):
			errors.append("Edge references unknown node: " + e.to)
	
	return errors
