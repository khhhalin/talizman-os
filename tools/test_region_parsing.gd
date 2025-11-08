extends Node

# Simple test runner for region expansion in BoardDataLoader
# Run this script in the editor (attach to a temporary node) to print results.

func _ready():
    var sample_regions = {
        "Outer": {
            "two way": [["n1","n2","n3","n4"]],
            "one way": [ {"n3":"n4"}, {"n4":"n1"} ]
        },
        "Inner": {
            "two-way": [ ["a","b","c"] ],
            "one-way": { "b": ["c", "a"] }
        }
    }
    # local expansion is inlined below if no autoload found

    var edges = []
    if Engine.has_singleton("BoardDataLoader") and get_node("/root/BoardDataLoader"):
        var b_loader = get_node("/root/BoardDataLoader")
        edges = b_loader._expand_regions_to_edges(sample_regions)
    else:
        # inline expansion (fallback)
        edges = []
        var two_keys = ["two_way", "two-way", "two way"]
        var one_keys = ["one_way", "one-way", "one way"]
        for r_name in sample_regions.keys():
            var r = sample_regions[r_name]
            if typeof(r) != TYPE_DICTIONARY:
                continue
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
            for ok in one_keys:
                if not r.has(ok):
                    continue
                var ow = r[ok]
                if typeof(ow) == TYPE_DICTIONARY:
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
                            for k2 in item.keys():
                                var v2 = item[k2]
                                if typeof(v2) == TYPE_ARRAY:
                                    for dest2 in v2:
                                        edges.append({"from": str(k2), "to": str(dest2), "directed": true})
                                else:
                                    edges.append({"from": str(k2), "to": str(v2), "directed": true})
    print("Expanded edges:")
    for e in edges:
        print(e)
    # Validate dedupe behavior: construct an explicit edges list and combine
    var explicit = [ {"from":"n1","to":"n2","directed":false}, {"from":"n2","to":"n1","directed":false} ]
    var combined = explicit + edges
    # We'll simulate the dedupe portion by calling the code via a small wrapper in this script
    var seen = {}
    var final = []
    for e in combined:
        var directed = bool(e.get("directed", false))
        var from_id = str(e.from)
        var to_id = str(e.to)
        var key = ""
        if directed:
            key = "%s|%s|1" % [from_id, to_id]
        else:
            if from_id <= to_id:
                key = "%s|%s|0" % [from_id, to_id]
            else:
                key = "%s|%s|0" % [to_id, from_id]
        if not seen.has(key):
            seen[key] = true
            final.append(e)
    print("Final deduped edges:")
    for e in final:
        print(e)
    get_tree().quit()
