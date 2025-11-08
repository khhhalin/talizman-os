extends Node

"""
MapValidator

Provides a small validation utility for map JSON structures.
Expose a single static-like function `validate(map)` that returns [errors, warnings].
"""

class_name MapValidator

static func validate(map: Dictionary) -> Array:
    var errors: Array = []
    var warnings: Array = []
    if typeof(map) != TYPE_DICTIONARY:
        errors.append("map must be a Dictionary")
        return [errors, warnings]

    if not map.has("nodes"):
        errors.append("no nodes array")
        return [errors, warnings]

    # check unique node ids
    var ids := {}
    for n in map.nodes:
        if typeof(n) != TYPE_DICTIONARY:
            errors.append("node entry is not a Dictionary: %s" % str(n))
            continue
        if not n.has("id"):
            errors.append("node with no id: %s" % str(n))
        else:
            if ids.has(n.id):
                errors.append("duplicate node id: %s" % n.id)
            ids[n.id] = true

    # build combined edges from explicit edges + regions so we can validate them
    var combined_edges: Array = []
    if map.has("edges") and typeof(map.edges) == TYPE_ARRAY:
        for e in map.edges:
            combined_edges.append(e)
    if map.has("_expanded_region_edges") and typeof(map._expanded_region_edges) == TYPE_ARRAY:
        for re in map._expanded_region_edges:
            combined_edges.append(re)

    for e in combined_edges:
        if typeof(e) != TYPE_DICTIONARY:
            errors.append("edge entry is not a Dictionary: %s" % str(e))
            continue
        if not e.has("from") or not e.has("to"):
            errors.append("edge missing from/to: %s" % str(e))
        else:
            var from_id = str(e.from)
            var to_id = str(e.to)
            if not ids.has(from_id) or not ids.has(to_id):
                errors.append("edge references unknown node: %s -> %s" % [from_id, to_id])

    return [errors, warnings]
