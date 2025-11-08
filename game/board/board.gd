@tool
extends Node2D

@export var rows: int = 8
@export var cols: int = 8
@export var spacing: Vector2 = Vector2(0, 0) # extra spacing between tiles
@export var tile_size: Vector2 = Vector2(32, 32)

# You can supply either a PackedScene or rely on the global Tile class (class_name Tile)
@export var tile_scene: PackedScene = preload("res://game/board/tile.tscn")
@export var color_map_file: String = "res://game/board/tile_colors.json"
@export var layout_file: String = "res://game/board/tile_layout.json"
@export var editor_rebuild: bool = false
@export var map_path: String = "res://config/map_demo.json"
@export var map_color_map_path: String = "" # optional override for color map when loading map
@export var auto_build_on_ready: bool = false

var _color_map: Dictionary = {}

func _load_color_map() -> void:
	_color_map.clear()
	var f = FileAccess.open(color_map_file, FileAccess.READ)
	if not f:
		push_warning("board.gd: color_map_file not found: %s" % color_map_file)
		return
	var text := f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(text)
	var parse_error = parsed.get("error", null) if typeof(parsed) == TYPE_DICTIONARY else null
	if parse_error != null and parse_error != OK:
		push_warning("board.gd: failed to parse JSON: %s" % str(parse_error))
		return
	_color_map = parsed.get("result", {}) if typeof(parsed) == TYPE_DICTIONARY else {}

func _load_layout() -> Array:
	var result: Array = []
	var f = FileAccess.open(layout_file, FileAccess.READ)
	if not f:
		return result
	var text := f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(text)
	var parse_error = parsed.get("error", null) if typeof(parsed) == TYPE_DICTIONARY else null
	if parse_error != null and parse_error != OK:
		return result
	return parsed.get("result", result) if typeof(parsed) == TYPE_DICTIONARY else result

# editor_rebuild is a manual toggle you can set in the inspector while editing to trigger a rebuild

func _ready() -> void:
	# In editor, we don't auto-build. At runtime, optionally build from map via BoardDataLoader.
	if Engine.is_editor_hint():
		return

	if auto_build_on_ready and map_path != "":
		var ok = false
		if Engine.has_singleton("BoardDataLoader"):
			# use autoload loader instance
			var loader = get_node("/root/BoardDataLoader")
			if loader:
				ok = loader.build_board_from_map(map_path, self, map_color_map_path)
		else:
			push_warning("board.gd: BoardDataLoader autoload not found; falling back to local builder")
		if not ok:
			# fallback to local grid builder
			_build_grid()
	else:
		_build_grid()

func build_from_map() -> bool:
	# public helper callable from editor/scripts to rebuild using BoardDataLoader
	if map_path == "":
		push_warning("board.gd: map_path not set")
		return false
	if not Engine.has_singleton("BoardDataLoader"):
		push_warning("board.gd: BoardDataLoader autoload not found")
		return false
	var loader = get_node("/root/BoardDataLoader")
	if not loader:
		push_warning("board.gd: failed to find /root/BoardDataLoader")
		return false
	return loader.build_board_from_map(map_path, self, map_color_map_path)

func _process(_delta: float) -> void:
	# editor live updates when properties change
	if Engine.is_editor_hint():
		# in-editor: request redraw if visualization toggle is set
		if has_method("update"):
			(self as CanvasItem).update()
		pass


func _draw() -> void:
	# draw edge visualization in editor when requested
	if not Engine.is_editor_hint():
		return
	if not has_meta("_editor_visualize_edges") and not (has_method("get") and get("_editor_visualize_edges")):
		# try property lookup
		pass
	var viz = false
	if has_method("get"):
		viz = bool(get("_editor_visualize_edges")) if has("_editor_visualize_edges") or get("_editor_visualize_edges") != null else false
	if not viz:
		return

	# draw simple lines between neighbors
	var child_count = get_child_count()
	for i in range(child_count):
		var n = get_child(i)
		if not n:
			continue
		if not n.has_method("get") and not n.has("neighbors"):
			continue
		var neigh = n.get("neighbors") if n.has("neighbors") else []
		for entry in neigh:
			var to_idx = int(entry.get("to", -1)) if typeof(entry) == TYPE_DICTIONARY else int(entry)
			if to_idx >= 0 and to_idx < child_count:
				var other = get_child(to_idx)
				if other:
					draw_line(n.position, other.position, Color(0.2, 0.8, 0.2, 0.9), 2.0)

func _clear_grid() -> void:
	for child in get_children():
		child.queue_free()

func _build_grid() -> void:
	# clear existing
	_clear_grid()

	# load color map and optional layout
	_load_color_map()
	var coords = _load_layout()
	if coords.is_empty():
		coords = _donut_coords(rows, cols)

	# try to preload tile script if no tile_scene provided
	var script = null
	if not tile_scene:
		script = ResourceLoader.load("res://game/board/tile.gd")

	# instantiate tiles along the provided path
	for i in range(coords.size()):
		var coord = coords[i]
		var x = int(coord.x)
		var y = int(coord.y)

		var instance: Node = null
		if tile_scene:
			instance = tile_scene.instantiate()
		elif script:
			instance = script.new()
		elif typeof(Tile) != TYPE_NIL:
			instance = Tile.new()
		else:
			push_error("board.gd: Failed to create Tile instance. Make sure tile_scene is set or tile.gd exists with class_name Tile.")
			return

		# position the tile; center the whole grid around origin
		var px: float = (x - (cols - 1) * 0.5) * (tile_size.x + spacing.x)
		var py: float = (y - (rows - 1) * 0.5) * (tile_size.y + spacing.y)
		instance.position = Vector2(px, py)

		# set tile size property if present
		if instance.has_method("set_tile_size"):
			instance.set_tile_size(tile_size)
		elif instance.has_method("set"):
			instance.set("size", tile_size)

		# determine tile type based on index (simple rules for demo)
		var tile_type: String = "rest"
		if i == 0:
			tile_type = "start"
		elif i % 11 == 0:
			tile_type = "special"
		elif i % 10 == 0:
			tile_type = "treasure"
		elif i % 7 == 0:
			tile_type = "boss"
		elif i % 5 == 0:
			tile_type = "shop"

		var props = {"tile_name": tile_type}
		if instance.has_method("apply_properties"):
			instance.apply_properties(props)
		elif instance.has_method("set"):
			instance.set("tile_name", tile_type)

		# set color from map or fallback
		var hex = _color_map.get(tile_type, null)
		if hex:
			var c = hex_to_color(str(hex))
			props["color"] = c
		else:
			props["color"] = Color(randf(), randf(), randf(), 1.0)

		if instance.has_method("apply_properties"):
			instance.apply_properties(props)
		elif instance.has_method("set"):
			if props.has("color"):
				instance.set("color", props["color"]) 

		# spot: show for special tiles
		var spot: float = 0.0
		if tile_type in ["start", "boss", "treasure", "shop", "special"]:
			spot = 0.25
		# include spot in props so it gets applied in one go when possible
		if spot > 0.0:
			props["spot_scale"] = spot
			props["spot_color"] = Color(0,0,0,1)
		elif spot == 0.0:
			props["spot_scale"] = 0.0

		# ensure props are applied if not already
		if not instance.has_method("apply_properties") and instance.has_method("set"):
			if props.has("spot_scale"):
				instance.set("spot_scale", props["spot_scale"]) 
			if props.has("spot_color"):
				instance.set("spot_color", props["spot_color"]) 

		# set grid metadata placeholder (neighbors assigned in second pass)
		if instance.has_method("set_grid"):
			# if the tile supports apply_properties, prefer to set grid metadata via that API
			if instance.has_method("apply_properties"):
				instance.apply_properties({"grid_index": i, "grid_x": x, "grid_y": y, "neighbors": []})
			else:
				instance.set_grid(i, x, y, [])

		add_child(instance)

	# second pass: compute neighbors along the path and assign neighbor indices
	var child_count = get_child_count()
	for i in range(child_count):
		var node = get_child(i)
		var prev_i = (i - 1 + child_count) % child_count
		var next_i = (i + 1) % child_count
		var neigh = [prev_i, next_i]
		if node and node.has_method("set_grid"):
			# preserve existing x,y by retrieving them from node properties if available
			var px = int(node.position.x)
			var py = int(node.position.y)
			node.set_grid(i, px, py, neigh)

func _donut_coords(r: int, c: int) -> Array:
	var coords: Array = []
	if r <= 0 or c <= 0:
		return coords
	# top row
	for x in range(c):
		coords.append(Vector2(x, 0))
	# right column (excluding corners)
	for y in range(1, r - 1):
		coords.append(Vector2(c - 1, y))
	# bottom row (if more than 1 row)
	if r > 1:
		for x in range(c - 1, -1, -1):
			coords.append(Vector2(x, r - 1))
	# left column (excluding corners)
	if c > 1:
		for y in range(r - 2, 0, -1):
			coords.append(Vector2(0, y))
	return coords

func hex_to_color(hex: String) -> Color:
	var s := hex.strip_edges()
	if s.begins_with("#"):
		s = s.substr(1, s.length() - 1)
	if s.length() == 6:
		var r = int("0x" + s.substr(0, 2)) / 255.0
		var g = int("0x" + s.substr(2, 2)) / 255.0
		var b = int("0x" + s.substr(4, 2)) / 255.0
		return Color(r, g, b, 1.0)
	elif s.length() == 8:
		var r = int("0x" + s.substr(0, 2)) / 255.0
		var g = int("0x" + s.substr(2, 2)) / 255.0
		var b = int("0x" + s.substr(4, 2)) / 255.0
		var a = int("0x" + s.substr(6, 2)) / 255.0
		return Color(r, g, b, a)
	return Color(1, 1, 1, 1)

func rebuild_grid() -> void:
	_build_grid()
