extends Node

"""
BoardDataLoader (autoload)

Responsibility: orchestrates map JSON parsing, region expansion, shape application,
validation, and board instantiation. Prefer to keep parsing/validation helpers
in separate modules (planned refactor) and keep this autoload as a thin facade.
"""

class_name BoardDataLoader

@export var default_tile_scene: PackedScene = preload("res://game/board/tile.tscn")
@export var default_color_map_file: String = "res://config/tile_colors.json"

var RegionParser = preload("res://game/board/regions.gd")
var MapValidator = preload("res://game/board/validator.gd")
var BoardBuilder = preload("res://game/board/BoardBuilder.gd")

# sensible defaults for spot markers depending on tile type
var DEFAULT_SPOT_SCALE := {
	"start": 0.6,
	"rest": 0.0,
	"boss": 0.55,
	"treasure": 0.45,
	"shop": 0.35,
	"special": 0.4
}

func _parse_json_file(path: String) -> Dictionary:
	var f = FileAccess.open(path, FileAccess.READ)
	if not f:
		push_error("BoardDataLoader: failed to open %s" % path)
		return {}
	var text := f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(text)
	if parsed.error != OK:
		push_error("BoardDataLoader: JSON parse error %s in %s" % [str(parsed.error), path])
		return {}
	return parsed.result

func load_color_map(path: String) -> Dictionary:
	var dict = _parse_json_file(path)
	if (typeof(dict) == TYPE_ARRAY or typeof(dict) == TYPE_DICTIONARY) and dict.is_empty():
		push_warning("BoardDataLoader: color map empty or failed to load: %s" % path)
	return dict

# validation now delegated to MapValidator


func _expand_regions_to_edges(regions: Dictionary) -> Array:
	# regions: flexible formats accepted.
	# Acceptable two-way keys: "two_way", "two-way", "two way"
	# Acceptable one-way keys: "one_way", "one-way", "one way"
	# two-way accepts:
	#  - array of arrays: [ [A,B,C], [D,E,F] ]
	#  - array of objects: [ {"two way": [A,B,C]}, ... ]
	# one-way accepts:
	#  - dict mapping: { A: B, C: [D,E] }
	#  - array of pairs: [ [A,B], [C,D] ]
	#  - array of single-entry dicts: [ {A: B}, {E: D} ]

	var edges: Array = []
	var two_keys = ["two_way", "two-way", "two way"]
	var one_keys = ["one_way", "one-way", "one way"]

	for r_name in regions.keys():
		var r = regions[r_name]
		if typeof(r) != TYPE_DICTIONARY:
			continue

		# ---- two-way parsing ----
		for tk in two_keys:
			if not r.has(tk):
				continue
			var two = r[tk]
			if typeof(two) == TYPE_ARRAY:
				for item in two:
					if typeof(item) == TYPE_ARRAY:
						var loop = item
						var L = loop.size()
						if L < 2:
							continue
						for i in range(L):
							var a = loop[i]
							var b = loop[(i + 1) % L]
							edges.append({"from": str(a), "to": str(b), "directed": false})
					elif typeof(item) == TYPE_DICTIONARY:
						# accept wrapper like {"two way": [A,B,C]}
						for k in item.keys():
							var inner = item[k]
							if typeof(inner) == TYPE_ARRAY:
								var L2 = inner.size()
								if L2 < 2:
									continue
								for i2 in range(L2):
									var a2 = inner[i2]
									var b2 = inner[(i2 + 1) % L2]
									edges.append({"from": str(a2), "to": str(b2), "directed": false})
					elif typeof(item) == TYPE_STRING:
						# single node id is meaningless for a loop; skip
						continue
			elif typeof(two) == TYPE_DICTIONARY:
				# maybe direct mapping: {"two way": { "loop1": [A,B,C] }}
				for k in two.keys():
					var val = two[k]
					if typeof(val) == TYPE_ARRAY:
						var L3 = val.size()
						if L3 < 2:
							continue
						for i3 in range(L3):
							var a3 = val[i3]
							var b3 = val[(i3 + 1) % L3]
							edges.append({"from": str(a3), "to": str(b3), "directed": false})

		# ---- one-way parsing ----
		for ok in one_keys:
			if not r.has(ok):
				continue
			var ow = r[ok]
			if typeof(ow) == TYPE_DICTIONARY:
				# mapping style: { A: B, C: [D,E] }
				for k in ow.keys():
					var v = ow[k]
					if typeof(v) == TYPE_ARRAY:
						for dest in v:
							edges.append({"from": str(k), "to": str(dest), "directed": true})
					else:
						edges.append({"from": str(k), "to": str(v), "directed": true})
			elif typeof(ow) == TYPE_ARRAY:
				for item in ow:
					if typeof(item) == TYPE_ARRAY and item.size() >= 2:
						edges.append({"from": str(item[0]), "to": str(item[1]), "directed": true})
					elif typeof(item) == TYPE_DICTIONARY:
						# single-entry dictionaries {A: B} or wrapper {"one way": {A:B}}
						for k2 in item.keys():
							var v2 = item[k2]
							if typeof(v2) == TYPE_ARRAY:
								for dest2 in v2:
									edges.append({"from": str(k2), "to": str(dest2), "directed": true})
							else:
								edges.append({"from": str(k2), "to": str(v2), "directed": true})
					elif typeof(item) == TYPE_STRING:
						# single string can't represent a pair; skip
						continue

	return edges

func build_board_from_map(map_path: String, board_node: Node, color_map_path: String = "", shape_path: String = "") -> bool:
	# loads map and builds children under board_node
	var color_map_file = color_map_path if color_map_path != "" else default_color_map_file
	var color_map = load_color_map(color_map_file)
	var map = _parse_json_file(map_path)

	# If a separate shape/layout file is provided, load it and apply to the map (sets x/y and adds missing nodes)
	if shape_path != "":
		var shape = _parse_json_file(shape_path)
		if (typeof(shape) == TYPE_ARRAY or typeof(shape) == TYPE_DICTIONARY) and not shape.is_empty():
			_apply_shape_to_map(shape, map)

	# If the JSON file uses regions as the top-level object (no "nodes" key),
	# detect and wrap it into { "regions": <file_contents> } so downstream logic works.
	if not map.has("nodes"):
		# quick heuristic: if any top-level value is a Dictionary that contains region keys
		var two_keys = ["two_way", "two-way", "two way"]
		var one_keys = ["one_way", "one-way", "one way"]
		var looks_like_regions = false
		for v in map.values():
			if typeof(v) == TYPE_DICTIONARY:
				for k in v.keys():
					if k in two_keys or k in one_keys:
						looks_like_regions = true
						break
                
            
			if looks_like_regions:
				break
            
        
		if looks_like_regions:
			map = {"regions": map}

	# If nodes are still missing but we have regions, infer node list from expanded region edges
	if not map.has("nodes") and map.has("regions"):
		var inferred_ids := {}
		var region_edges = _expand_regions_to_edges(map.regions)
		for e in region_edges:
			var f = str(e.get("from", "")).strip_edges()
			if f.length() > 0 and f.substr(f.length() - 1, 1) == ":":
				f = f.substr(0, f.length() - 1)
            
			inferred_ids[f] = true
			var t = str(e.get("to", "")).strip_edges()
			if t.length() > 0 and t.substr(t.length() - 1, 1) == ":":
				t = t.substr(0, t.length() - 1)
            
			inferred_ids[t] = true
        
		var nodes_arr: Array = []
		for id in inferred_ids.keys():
			if id != "":
				nodes_arr.append({"id": id})
            
        
		map["nodes"] = nodes_arr
	# expand regions into edges if present so validation and building see a unified edge list
	if map.has("regions"):
		map["_expanded_region_edges"] = _expand_regions_to_edges(map.regions)

	var res = MapValidator.validate(map)
	if res[0].size() > 0:
		for e in res[0]:
			push_error("BoardDataLoader: " + str(e))
		return false

	# delegate instantiation and neighbor wiring to BoardBuilder
	var builder = BoardBuilder.new()
	var ok = builder.build(board_node, map, color_map, default_tile_scene, DEFAULT_SPOT_SCALE)
	if not ok:
		push_error("BoardDataLoader: BoardBuilder failed to build board")
		return false
	return true

func _node_index_by_id(nodes_array: Array, id: String) -> int:
	for i in range(nodes_array.size()):
		if nodes_array[i].id == id:
			return i
	return -1


func _apply_shape_to_map(shape: Variant, map: Dictionary) -> void:
	# shape can be:
	#  - an Array of Arrays (rows): [ [A,B], [C,D] ]
	#  - a Dictionary with key "rows" or "grid": {"rows": [ [...] ]}
	var rows: Array = []
	if typeof(shape) == TYPE_ARRAY:
		rows = shape
	elif typeof(shape) == TYPE_DICTIONARY:
		if shape.has("rows"):
			rows = shape.rows
		elif shape.has("grid"):
			rows = shape.grid
		else:
			# try to interpret dictionary entries as named rows in insertion order
			for k in shape.keys():
				var val = shape[k]
				if typeof(val) == TYPE_ARRAY:
					rows.append(val)
	else:
		return

	# ensure map.nodes exists
	if not map.has("nodes"):
		map["nodes"] = []

	# build id->node lookup for quick find
	var id_to_node := {}
	for n in map.nodes:
		if n.has("id"):
			id_to_node[str(n.id)] = n

	for y in range(rows.size()):
		var row = rows[y]
		if typeof(row) != TYPE_ARRAY:
			continue
		for x in range(row.size()):
			var cell = row[x]
			var cell_id = str(cell)
			# clean quotes/spaces
			cell_id = cell_id.strip_edges()
			if cell_id == "":
				continue
			if id_to_node.has(cell_id):
				var node = id_to_node[cell_id]
				node["x"] = x
				node["y"] = y
			else:
				var newn = {"id": cell_id, "x": x, "y": y}
				map.nodes.append(newn)
				id_to_node[cell_id] = newn


func _hex_to_color(h: String) -> Color:
	var s := h.strip_edges()
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
