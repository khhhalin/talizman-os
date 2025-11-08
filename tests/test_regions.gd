extends Node

# Run this in the editor to verify region parsing
func _ready():
    var samples = [
        {
            "Outer": { "two way": [["n1","n2","n3","n4"]], "one way": [ {"n3":"n4"} ] }
        },
        {
            "RegionA": { "two-way": [ ["a","b","c"] ], "one-way": { "b": ["c", "a"] } }
        },
        {
            "R": { "two_way": { "loop": ["x","y"] }, "one_way": { "x":"y" } }
        }
    ]
    for s in samples:
        print("--- sample ---")
        var edges = preload("res://game/board/regions.gd").expand(s)
        for e in edges:
            print(e)
    get_tree().quit()
