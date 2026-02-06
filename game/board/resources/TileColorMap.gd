@tool
class_name TileColorMap
extends Resource

const ColorUtils = preload("res://game/board/ColorUtils.gd")

## Resource defining color mappings for tile types.
## Use this instead of JSON files for better editor integration.

@export var mappings: Dictionary = {
	"forest": Color("#FFD700"),
	"jungle": Color("#CCCCCC"),
	"volcano": Color("#FF5C5C"),
	"citadel": Color("#66CC66"),
	"desert": Color("#66B2FF"),
	"ruins": Color("#CC66FF"),
	"rocks": Color("#A9A9A9"),
	"rest": Color("#AAAAAA"),
	"start": Color("#00FF00"),
	"special": Color("#FF00FF"),
	"treasure": Color("#FFFF00"),
	"boss": Color("#FF0000"),
	"shop": Color("#00FFFF")
}

func get_color(tile_type: String) -> Color:
	return mappings.get(tile_type, Color.WHITE)

func set_color(tile_type: String, color: Color) -> void:
	mappings[tile_type] = color

func has_color(tile_type: String) -> bool:
	return mappings.has(tile_type)

## Load from JSON dictionary (for backwards compatibility)
static func from_json(json_dict: Dictionary) -> TileColorMap:
	var map = TileColorMap.new()
	for key in json_dict.keys():
		var hex = json_dict[key]
		if typeof(hex) == TYPE_STRING:
			map.set_color(key, ColorUtils.hex_to_color(hex))
	return map
