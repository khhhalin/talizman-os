extends Node

var MapValidator = preload("res://game/board/validator.gd")

func _ready():
	print("Running validator tests...")

	var good_map = {
		"nodes": [ {"id":"A"}, {"id":"B"} ],
		"edges": [ {"from":"A", "to":"B"} ]
	}
	var res = MapValidator.validate(good_map)
	print("good_map errors:", res[0])

	var bad_map = { "nodes": [ {"id":"A"} ], "edges": [ {"from":"A", "to":"B"} ] }
	var res2 = MapValidator.validate(bad_map)
	print("bad_map errors:", res2[0])

	get_tree().quit()
