@tool
class_name Tile
extends Node2D

"""
Tile: a small, self-drawing board tile node.

Exports:
 - color (Color)
 - size (Vector2) — used for rectangle or to compute circle radius
 - shape (enum) — RECTANGLE or CIRCLE
 - filled (bool)

The tile draws itself in _draw() and updates live in the editor thanks to @tool.
"""

enum Shape {RECTANGLE, CIRCLE}

@export var color: Color = Color(1, 1, 1, 1)
@export var size: Vector2 = Vector2(32, 32)
@export var shape: int = Shape.RECTANGLE
@export var filled: bool = true
@export var tile_name: String = ""
@export var spot_scale: float = 0.0 # 0.0 = no spot, 0.2 = small, 0.5 = medium
@export var spot_color: Color = Color(0, 0, 0, 1)

# Grid metadata (set by Board)
var grid_index: int = -1
var grid_x: int = -1
var grid_y: int = -1
var neighbors: Array = []

func set_grid(idx: int, x: int, y: int, neigh: Array) -> void:
	grid_index = idx
	grid_x = x
	grid_y = y
	neighbors = neigh
	# When grid metadata changes, request redraw so inspector shows correct state
	if has_method("update"):
		(self as CanvasItem).update()


func apply_properties(props: Dictionary) -> void:
	"""Apply a dictionary of properties coming from the board builder or loader.
	This centralizes how external code configures a Tile instance.
	Supported keys: tile_name, color (Color), spot_scale (float), spot_color (Color),
	grid_index, grid_x, grid_y, neighbors (Array).
	"""
	if typeof(props) != TYPE_DICTIONARY:
		return
	if props.has("tile_name"):
		tile_name = str(props.tile_name)
	if props.has("color") and props.color is Color:
		color = props.color
	if props.has("spot_scale"):
		spot_scale = float(props.spot_scale)
	if props.has("spot_color") and props.spot_color is Color:
		spot_color = props.spot_color
	if props.has("grid_index"):
		grid_index = int(props.grid_index)
	if props.has("grid_x"):
		grid_x = int(props.grid_x)
	if props.has("grid_y"):
		grid_y = int(props.grid_y)
	if props.has("neighbors") and typeof(props.neighbors) == TYPE_ARRAY:
		neighbors = props.neighbors

	if has_method("update"):
		(self as CanvasItem).update()


func get_neighbors() -> Array:
	return neighbors


func set_tile_size(s: Vector2) -> void:
	"""Helper to set tile visual size from external callers."""
	size = s

func _process(_delta: float) -> void:
	# In-editor live preview: keep drawing updated while editing properties.
	if Engine.is_editor_hint():
		if has_method("update"):
			(self as CanvasItem).update()

func _ready() -> void:
	# Ensure the tile is drawn initially
	if has_method("update"):
		(self as CanvasItem).update()

func _draw() -> void:
	match shape:
		Shape.RECTANGLE:
			_draw_rect()

		Shape.CIRCLE:
			_draw_circle()

	# Draw spot marker (depends on tile type)
	if spot_scale > 0.0:
		var spot_r: float = min(size.x, size.y) * 0.5 * clamp(spot_scale, 0.0, 1.0)
		# draw spot at center by default; could be offset if needed
		draw_circle(Vector2.ZERO, spot_r, spot_color)


func _draw_rect() -> void:
	var rect := Rect2(-size * 0.5, size)
	draw_rect(rect, color, filled)


func _draw_circle() -> void:
	var r: float = max(size.x, size.y) * 0.5
	if filled:
		draw_circle(Vector2.ZERO, r, color)
	else:
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 64, color, 2.0)
