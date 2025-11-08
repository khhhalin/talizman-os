extends Node

var BoardBuilder = preload("res://game/board/BoardBuilder.gd")
var TileScene = preload("res://game/board/tile.tscn")

func _ready():
    print("Running BoardBuilder tests...")

    var map = {
        "nodes": [ {"id":"A"}, {"id":"B"}, {"id":"C"} ],
        "edges": [ {"from":"A","to":"B"}, {"from":"B","to":"C"} ]
    }

    var color_map = { "rest": "#aaaaaa" }
    var board = Node2D.new()
    add_child(board)

    var builder = BoardBuilder.new()
    var ok = builder.build(board, map, color_map, TileScene, {})
    print("build ok:", ok)
    print("children:", board.get_child_count())

    # basic sanity checks
    assert(ok == true)
    assert(board.get_child_count() == 3)

    get_tree().quit()