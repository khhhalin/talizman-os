extends Node

"""
BoardBuilder

Responsibility: instantiate tile scenes under a board node from a parsed map
dictionary, apply colors/spot defaults, and wire neighbor relationships.
"""

class_name BoardBuilder

func build(board_node: Node, map: Dictionary, color_map: Dictionary, default_tile_scene: PackedScene, default_spot_scale: Dictionary) -> bool:
    # clear board
    for c in board_node.get_children():
        c.queue_free()

    var node_lookup = {}
    var index = 0
    for n in map.nodes:
        node_lookup[n.id] = {"node": n, "index": index}
        var inst: Node = null
        if n.has("scene"):
            var res_scene = ResourceLoader.load(n.scene)
            if res_scene and res_scene is PackedScene:
                inst = res_scene.instantiate()
            else:
                push_warning("BoardBuilder: failed to load scene %s for node %s, using default" % [str(n.scene), str(n.id)])
                inst = default_tile_scene.instantiate()
        else:
            inst = default_tile_scene.instantiate()

        # position
        if n.has("x") and n.has("y"):
            inst.position = Vector2(float(n.x), float(n.y))
        else:
            inst.position = Vector2(0, 0)

        # set properties including color and spot defaults
        var tile_type = str(n.get("tile", "rest"))
        var hex = color_map.get(tile_type, null)
        var col = _hex_to_color(str(hex)) if hex else Color(randf(), randf(), randf(), 1.0)
        var spot = float(n.get("spot_scale", default_spot_scale.get(tile_type, 0.0)))
        var spot_col = _hex_to_color(str(n.spot_color)) if n.has("spot_color") else Color(0,0,0,1)

        var props = {
            "tile_name": tile_type,
            "color": col,
            "spot_scale": spot,
            "spot_color": spot_col,
            "grid_index": index,
            "grid_x": int(n.get("x", 0)),
            "grid_y": int(n.get("y", 0))
        }
        if inst.has_method("apply_properties"):
            inst.apply_properties(props)
        elif inst.has_method("set"):
            inst.set("tile_name", tile_type)
            inst.set("color", col)
            inst.set("spot_scale", spot)
            inst.set("spot_color", spot_col)
            inst.set("grid_index", index)
            inst.set("grid_x", int(n.get("x", 0)))
            inst.set("grid_y", int(n.get("y", 0)))

        board_node.add_child(inst)
        index += 1

    # build combined edge list (explicit edges + expanded region edges)
    var combined_edges: Array = []
    if map.has("edges") and typeof(map.edges) == TYPE_ARRAY:
        for e in map.edges:
            combined_edges.append(e)
    if map.has("_expanded_region_edges") and typeof(map._expanded_region_edges) == TYPE_ARRAY:
        for e in map._expanded_region_edges:
            combined_edges.append(e)

    # dedupe edges (from,to,directed)
    var seen := {}
    var edges_final: Array = []
    for e in combined_edges:
        var directed = bool(e.get("directed", false))
        var from_id = str(e.from)
        var to_id = str(e.to)
        var key: String
        if directed:
            key = "%s|%s|1" % [from_id, to_id]
        else:
            if from_id <= to_id:
                key = "%s|%s|0" % [from_id, to_id]
            else:
                key = "%s|%s|0" % [to_id, from_id]
        if not seen.has(key):
            seen[key] = true
            edges_final.append(e)

    # assign neighbors; ensure undirected edges add reverse neighbor
    for e in edges_final:
        var from_idx = _node_index_by_id(map.nodes, e.from)
        var to_idx = _node_index_by_id(map.nodes, e.to)
        if from_idx < 0 or to_idx < 0:
            # validation should have caught this; be defensive
            continue
        var from_node = board_node.get_child(from_idx)
        var to_node = board_node.get_child(to_idx)

        var directed = bool(e.get("directed", false))

        # append neighbor to source
        var neigh_from = from_node.get("neighbors") if from_node.has("neighbors") else []
        neigh_from.append({"to": to_idx, "directed": directed})
        if from_node.has_method("set_grid"):
            from_node.set_grid(from_node.get("grid_index"), from_node.get("grid_x"), from_node.get("grid_y"), neigh_from)

        # if undirected, also append reverse
        if not directed:
            var neigh_to = to_node.get("neighbors") if to_node.has("neighbors") else []
            neigh_to.append({"to": from_idx, "directed": false})
            if to_node.has_method("set_grid"):
                to_node.set_grid(to_node.get("grid_index"), to_node.get("grid_x"), to_node.get("grid_y"), neigh_to)

    return true

func _node_index_by_id(nodes_array: Array, id: String) -> int:
    for i in range(nodes_array.size()):
        if nodes_array[i].id == id:
            return i
    return -1

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
