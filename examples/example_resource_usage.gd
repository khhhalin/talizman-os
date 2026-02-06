extends Node

## Example showing how to use the new Godot Resources
## instead of JSON files for board configuration

func _ready():
	example_color_map()
	example_tile_data()
	example_color_utils()
	print("All examples completed successfully!")

## Example 1: Using TileColorMap Resource
func example_color_map():
	print("\n=== Example 1: TileColorMap ===")
	
	# Create a new color map
	var color_map = TileColorMap.new()
	
	# Get a color
	var forest_color = color_map.get_color("forest")
	print("Forest color: ", forest_color)
	
	# Set a custom color
	color_map.set_color("custom_tile", Color.PURPLE)
	print("Custom tile color: ", color_map.get_color("custom_tile"))
	
	# Check if color exists
	if color_map.has_color("boss"):
		print("Boss color exists: ", color_map.get_color("boss"))
	
	# Load from preload (if .tres file exists)
	# var saved_map = preload("res://config/tile_colors.tres")
	# print("Loaded map has citadel: ", saved_map.has_color("citadel"))

## Example 2: Using TileData Resource
func example_tile_data():
	print("\n=== Example 2: TileData ===")
	
	# Create tile data for a boss tile
	var boss_data = TileData.new("boss", Color.RED)
	boss_data.spot_scale = 0.5
	boss_data.spot_color = Color.BLACK
	boss_data.shape = Tile.Shape.CIRCLE
	
	print("Boss tile name: ", boss_data.tile_name)
	print("Boss tile color: ", boss_data.color)
	print("Boss tile spot scale: ", boss_data.spot_scale)
	
	# You could save this as a .tres file:
	# ResourceSaver.save(boss_data, "res://config/tiles/boss_tile.tres")
	
	# And load it later:
	# var loaded_data = preload("res://config/tiles/boss_tile.tres")

## Example 3: Using ColorUtils
func example_color_utils():
	print("\n=== Example 3: ColorUtils ===")
	
	# Convert hex to color
	var red = ColorUtils.hex_to_color("#FF0000")
	print("Red from hex: ", red)
	
	# Convert hex with alpha
	var semi_transparent = ColorUtils.hex_to_color("#FF000080")
	print("Semi-transparent red: ", semi_transparent)
	
	# Convert color to hex
	var hex = ColorUtils.color_to_hex(Color.GREEN)
	print("Green as hex: ", hex)
	
	# Convert color to hex with alpha
	var hex_with_alpha = ColorUtils.color_to_hex(Color(1, 0, 0, 0.5), true)
	print("Red with alpha as hex: ", hex_with_alpha)

## Example 4: Creating a board programmatically
func example_board_creation():
	print("\n=== Example 4: Board Creation ===")
	
	# Create a board node
	var board = Node2D.new()
	add_child(board)
	
	# Create color map
	var color_map = TileColorMap.new()
	
	# Create tiles programmatically
	var tile_scene = preload("res://game/board/tile.tscn")
	
	for i in range(5):
		var tile = tile_scene.instantiate()
		tile.position = Vector2(i * 40, 0)
		
		var tile_data = TileData.new("tile_" + str(i))
		tile_data.color = Color(randf(), randf(), randf())
		
		tile.apply_properties({
			"tile_name": tile_data.tile_name,
			"color": tile_data.color,
			"grid_index": i,
			"grid_x": i,
			"grid_y": 0
		})
		
		board.add_child(tile)
	
	print("Created board with ", board.get_child_count(), " tiles")

## Example 5: Loading from JSON (backwards compatibility)
func example_json_loading():
	print("\n=== Example 5: JSON Loading (Legacy) ===")
	
	# Load JSON color map
	var json_dict = {
		"forest": "#FFD700",
		"water": "#0000FF",
		"mountain": "#8B4513"
	}
	
	# Convert to TileColorMap resource
	var color_map = TileColorMap.from_json(json_dict)
	
	print("Forest from JSON: ", color_map.get_color("forest"))
	print("Water from JSON: ", color_map.get_color("water"))
	print("Mountain from JSON: ", color_map.get_color("mountain"))
	
	# Now you can save this as a .tres file for future use
	# ResourceSaver.save(color_map, "res://config/converted_colors.tres")

## Example 6: Using BoardMapData (future)
func example_board_map_data():
	print("\n=== Example 6: BoardMapData (Future) ===")
	
	# This is how you'll create maps in the future
	var map_data = BoardMapData.new()
	
	# Create nodes
	var node1 = BoardMapData.NodeData.new()
	node1.id = "start"
	node1.x = 0
	node1.y = 0
	node1.tile_type = "start"
	
	var node2 = BoardMapData.NodeData.new()
	node2.id = "end"
	node2.x = 5
	node2.y = 5
	node2.tile_type = "treasure"
	
	map_data.nodes = [node1, node2]
	
	# Create edges
	var edge = BoardMapData.EdgeData.new()
	edge.from = "start"
	edge.to = "end"
	edge.directed = false
	
	map_data.edges = [edge]
	
	# Validate
	var errors = map_data.validate()
	if errors.is_empty():
		print("Map data is valid!")
	else:
		print("Map has errors: ", errors)
	
	# Save as resource
	# ResourceSaver.save(map_data, "res://config/maps/example_map.tres")
