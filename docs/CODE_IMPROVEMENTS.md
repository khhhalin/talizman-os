# Code Improvements & Best Practices

## Overview
This document outlines additional improvements and best practices for the Talizman OS codebase.

## Completed Improvements

### ✅ 1. Created Godot Resources
- **TileData.gd**: Type-safe tile configuration
- **TileColorMap.gd**: Visual color mapping with editor support
- **BoardMapData.gd**: Structured map data with validation
- **ColorUtils.gd**: Centralized color conversion utilities

### ✅ 2. Fixed Code Quality Issues
- Standardized indentation to tabs
- Fixed JSON parsing errors
- Removed code duplication (hex_to_color)
- Improved error handling and validation
- Added proper documentation comments

### ✅ 3. Reduced Dependencies
- Board.gd no longer requires BoardDataLoader autoload
- Graceful fallbacks when optional components missing
- Loose coupling between modules

### ✅ 4. Fixed Data Issues
- Corrected "cittadel" → "citadel" typo
- Removed extra colon from "rocks:"
- Added missing color definitions

## Recommended Improvements

### High Priority

#### 1. Move to Resource-Based Configuration
**Current**: JSON files for colors and maps
**Proposed**: .tres resource files

```gdscript
# Instead of:
@export var color_map_file: String = "res://config/tile_colors.json"

# Use:
@export var color_map: TileColorMap = preload("res://config/tile_colors.tres")
```

**Benefits**:
- Visual editing in Inspector
- No runtime JSON parsing
- Type safety
- Better performance

#### 2. Create BoardConfig Resource
```gdscript
@tool
class_name BoardConfig
extends Resource

@export var tile_scene: PackedScene
@export var color_map: TileColorMap
@export var default_tile_size: Vector2 = Vector2(32, 32)
@export var spacing: Vector2 = Vector2(0, 0)
@export var rows: int = 8
@export var cols: int = 8
```

This encapsulates all board configuration in one place.

#### 3. Simplify Board.gd
Remove unused variables and methods:
- `layout_file` (if not used)
- `editor_rebuild` (replaced by plugin)
- Duplicate position calculation code

#### 4. Use Signals for Board Events
```gdscript
signal board_built(tile_count: int)
signal board_cleared()
signal tile_added(tile: Tile, index: int)
```

This allows better decoupling and event-driven architecture.

### Medium Priority

#### 5. Create TileType Enum
Instead of string-based tile types:
```gdscript
enum TileType {
	REST,
	START,
	BOSS,
	TREASURE,
	SHOP,
	SPECIAL,
	FOREST,
	JUNGLE,
	VOLCANO,
	CITADEL,
	DESERT,
	RUINS,
	ROCKS
}
```

**Benefits**:
- Autocomplete support
- Type safety
- Refactoring support
- Performance (int vs string comparison)

#### 6. Implement Object Pooling for Tiles
For large boards with many tiles:
```gdscript
class_name TilePool
extends Node

var _pool: Array[Tile] = []
var _active: Array[Tile] = []

func get_tile() -> Tile:
	if _pool.is_empty():
		return _create_tile()
	return _pool.pop_back()

func return_tile(tile: Tile) -> void:
	tile.visible = false
	_pool.append(tile)
```

#### 7. Add Tile Animation Support
```gdscript
# In Tile.gd
@export var hover_animation: Animation
@export var select_animation: Animation

func animate_hover() -> void:
	# Scale up, glow effect, etc.
	pass
```

#### 8. Create Board Editor Tool
EditorPlugin for visual board editing:
- Drag-and-drop tile placement
- Visual edge drawing
- Property editing per tile
- Save/load board configurations

### Low Priority

#### 9. Implement Board Serialization
```gdscript
func serialize() -> Dictionary:
	var data = {}
	for tile in get_children():
		data[tile.grid_index] = tile.serialize()
	return data

func deserialize(data: Dictionary) -> void:
	for idx in data:
		var tile = get_child(idx)
		tile.deserialize(data[idx])
```

#### 10. Add Board Navigation System
```gdscript
class_name BoardNavigator
extends Node

func find_path(from: Tile, to: Tile) -> Array[Tile]:
	return _astar_search(from, to)

func get_reachable_tiles(from: Tile, range: int) -> Array[Tile]:
	return _breadth_first_search(from, range)
```

#### 11. Optimize Edge Visualization
Use `RenderingServer` for better performance:
```gdscript
func _draw_edges_optimized() -> void:
	var rid = get_canvas_item()
	for edge in _edges:
		RenderingServer.canvas_item_add_line(
			rid, edge.from, edge.to,
			Color.GREEN, 2.0
		)
```

#### 12. Add Board State Machine
```gdscript
enum BoardState { SETUP, READY, PLAYING, PAUSED, ENDED }

var _state: BoardState = BoardState.SETUP

func change_state(new_state: BoardState) -> void:
	if _state == new_state:
		return
	_exit_state(_state)
	_state = new_state
	_enter_state(_state)
```

## Architecture Improvements

### 1. Separate Concerns
```
game/board/
├── core/              # Core board logic
│   ├── Board.gd
│   └── Tile.gd
├── data/              # Data structures
│   ├── BoardMapData.gd
│   └── TileData.gd
├── builders/          # Construction logic
│   ├── BoardBuilder.gd
│   └── BoardDataLoader.gd
├── utils/             # Utilities
│   ├── ColorUtils.gd
│   └── RegionParser.gd
└── validation/        # Validation
    └── MapValidator.gd
```

### 2. Use Composition Over Inheritance
Instead of one monolithic Board class, compose from smaller components:
```gdscript
# Board.gd
@onready var renderer := $BoardRenderer
@onready var navigator := $BoardNavigator
@onready var state_machine := $BoardStateMachine
```

### 3. Implement Repository Pattern
```gdscript
class_name TileRepository
extends Node

func get_tile_by_id(id: String) -> Tile:
	pass

func get_tiles_by_type(type: TileType) -> Array[Tile]:
	pass

func find_tile_at_position(pos: Vector2) -> Tile:
	pass
```

## Performance Optimizations

### 1. Lazy Loading
Don't load all tiles at once:
```gdscript
func _load_tiles_async() -> void:
	for i in range(tile_count):
		_load_tile(i)
		if i % 10 == 0:
			await get_tree().process_frame
```

### 2. Spatial Indexing
For fast position queries:
```gdscript
var _spatial_grid: Dictionary = {}  # grid_key -> [tiles]

func _add_to_spatial_grid(tile: Tile) -> void:
	var key = _get_grid_key(tile.position)
	if not _spatial_grid.has(key):
		_spatial_grid[key] = []
	_spatial_grid[key].append(tile)
```

### 3. Dirty Flag Pattern
Only recalculate when needed:
```gdscript
var _dirty: bool = true
var _cached_neighbors: Array[Tile] = []

func get_neighbors() -> Array[Tile]:
	if _dirty:
		_cached_neighbors = _calculate_neighbors()
		_dirty = false
	return _cached_neighbors
```

## Testing Improvements

### 1. Unit Test Coverage
Add tests for:
- ColorUtils conversions
- TileColorMap operations
- BoardMapData validation
- Region parsing edge cases

### 2. Integration Tests
```gdscript
# test_board_integration.gd
func test_full_board_build_from_json():
	var board = Board.new()
	var success = board.build_from_map()
	assert_true(success)
	assert_equal(board.get_child_count(), expected_tile_count)
```

### 3. Performance Benchmarks
```gdscript
func benchmark_tile_creation():
	var start = Time.get_ticks_usec()
	for i in range(1000):
		var tile = Tile.new()
	var end = Time.get_ticks_usec()
	print("Tile creation: ", (end - start) / 1000.0, "ms")
```

## Documentation Improvements

### 1. Add Inline Examples
```gdscript
## Creates a new tile with the given properties.
##
## Example:
## [codeblock]
## var tile = Tile.new()
## tile.apply_properties({"color": Color.RED, "tile_name": "boss"})
## [/codeblock]
func apply_properties(props: Dictionary) -> void:
```

### 2. Create Tutorial Scenes
- `tutorial_01_basic_board.tscn`: Simple board setup
- `tutorial_02_custom_tiles.tscn`: Custom tile types
- `tutorial_03_complex_map.tscn`: Using JSON maps
- `tutorial_04_resources.tscn`: Using Resources

### 3. Add README per Module
```markdown
# game/board/README.md

## Board System

The board system handles game board creation, tile management, and navigation.

### Quick Start
1. Add Board node to scene
2. Configure tile_scene and color_map
3. Set map_path or use auto-generated grid
4. Call build_from_map() or let auto_build_on_ready work
```

## Code Style Guidelines

### 1. Naming Conventions
- **Classes**: PascalCase (TileData, BoardBuilder)
- **Functions**: snake_case (build_from_map, get_color)
- **Constants**: UPPER_SNAKE_CASE (DEFAULT_PORT, MAX_PEERS)
- **Private vars**: _leading_underscore (_color_map, _cached_data)
- **Signals**: past_tense (board_built, tile_clicked)

### 2. Type Hints
Always use type hints:
```gdscript
func get_tile(index: int) -> Tile:
	return _tiles[index] as Tile
```

### 3. Documentation
Use `##` for public API:
```gdscript
## Returns the color for the given tile type.
## Returns Color.WHITE if type not found.
func get_color(tile_type: String) -> Color:
```

### 4. Error Handling
```gdscript
# Bad
func load_file(path: String):
	var f = FileAccess.open(path, FileAccess.READ)
	return f.get_as_text()

# Good
func load_file(path: String) -> String:
	var f = FileAccess.open(path, FileAccess.READ)
	if not f:
		push_error("Failed to open file: " + path)
		return ""
	return f.get_as_text()
```

## Migration Checklist

When moving to new architecture:

- [ ] Create .tres resource files for existing JSON data
- [ ] Update export variables to use Resources
- [ ] Test all scenes with new resources
- [ ] Update documentation and examples
- [ ] Deprecate old JSON loading (keep for compatibility)
- [ ] Add migration tools if needed
- [ ] Update tutorials and demos
- [ ] Remove deprecated code after grace period

## Conclusion

These improvements will make the codebase:
- More maintainable
- Better performing
- Easier to extend
- More Godot-idiomatic
- Safer and less error-prone

Implement changes incrementally, testing thoroughly at each stage.
