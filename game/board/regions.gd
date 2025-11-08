extends Node

class_name RegionParser

"""
RegionParser.expand(regions: Dictionary) -> Array

Parses flexible region definitions and returns an array of edges:
each edge is {"from": "id", "to": "id", "directed": bool}

Supported region formats include multiple variants of "two way" and "one way".
"""

static func expand(regions: Dictionary) -> Array:
    var edges: Array = []
    var two_keys = ["two_way", "two-way", "two way"]
    var one_keys = ["one_way", "one-way", "one way"]

    for r_name in regions.keys():
        var r = regions[r_name]
        if typeof(r) != TYPE_DICTIONARY:
            continue

        # two-way parsing
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
            elif typeof(two) == TYPE_DICTIONARY:
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

        # one-way parsing
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

    return edges
