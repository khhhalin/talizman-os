@tool
class_name TileData
extends Resource

## Resource defining visual and gameplay properties for a tile type.
## Use this instead of parsing JSON dictionaries everywhere.

@export var tile_name: String = "rest"
@export var color: Color = Color(0.8, 0.8, 0.8)
@export var spot_scale: float = 0.0  ## 0.0 = no spot, 0.5 = medium spot
@export var spot_color: Color = Color(0, 0, 0, 1)
@export var shape: Tile.Shape = Tile.Shape.RECTANGLE
@export var filled: bool = true

func _init(p_tile_name: String = "rest", p_color: Color = Color.WHITE) -> void:
	tile_name = p_tile_name
	color = p_color
