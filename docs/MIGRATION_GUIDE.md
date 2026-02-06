# Migration Guide: JSON to Godot Resources

## Overview
This guide helps you migrate from JSON-based configuration to Godot Resources for better editor integration and performance.

## Why Migrate?

### Benefits of Resources
- ✅ **Visual editing** in Inspector with color pickers, sliders, etc.
- ✅ **Type safety** catches errors at edit-time
- ✅ **Better performance** - no JSON parsing at runtime
- ✅ **Editor integration** - autocomplete, validation, preview
- ✅ **Reusability** - share resources across scenes
- ✅ **Version control** - can use text or binary format

### Backwards Compatibility
All JSON functionality still works! You can migrate gradually.

## Step-by-Step Migration

### 1. Migrating Color Maps

#### Before (JSON)
```json
// config/tile_colors.json
{
  "forest": "#FFD700",
  "jungle": "#CCCCCC",
  "volcano": "#FF5C5C"
}
```

```gdscript
# In your script
@export var color_map_file: String = "res://config/tile_colors.json"

func _load_color_map():
    var f = FileAccess.open(color_map_file, FileAccess.READ)
    var text = f.get_as_text()
    var json = JSON.parse_string(text)
    # ... use json
```

#### After (Resource)
```gdscript
# In your script
@export var color_map: TileColorMap = preload("res://config/tile_colors.tres")

func _ready():
    var forest_color = color_map.get_color("forest")
    # That's it! No parsing needed
```

#### Converting Existing JSON
```gdscript
# One-time conversion script
func convert_json_to_resource():
    var json_dict = {
        "forest": "#FFD700",
        "jungle": "#CCCCCC",
        "volcano": "#FF5C5C"
    }
    
    var color_map = TileColorMap.from_json(json_dict)
    ResourceSaver.save(color_map, "res://config/tile_colors.tres")
    print("Conversion complete!")
```

### 2. Migrating Tile Configuration

#### Before (Dictionary)
```gdscript
var tile_props = {
    "tile_name": "boss",
    "color": Color.RED,
    "spot_scale": 0.5,
    "spot_color": Color.BLACK
}
tile.apply_properties(tile_props)
```

#### After (Resource)
```gdscript
@export var boss_tile_data: TileData = preload("res://config/tiles/boss.tres")

func setup_tile(tile: Tile):
    tile.apply_properties({
        "tile_name": boss_tile_data.tile_name,
        "color": boss_tile_data.color,
        "spot_scale": boss_tile_data.spot_scale,
        "spot_color": boss_tile_data.spot_color
    })
```

Or even better:
```gdscript
# Add to Tile.gd
func apply_tile_data(data: TileData) -> void:
    tile_name = data.tile_name
    color = data.color
    spot_scale = data.spot_scale
    spot_color = data.spot_color
    shape = data.shape
    filled = data.filled
    queue_redraw()

# Usage
tile.apply_tile_data(boss_tile_data)
```

### 3. Creating Resource Files in Editor

#### Method 1: Through FileSystem
1. Right-click in FileSystem panel
2. Select "New Resource..."
3. Search for "TileColorMap" or "TileData"
4. Click "Create"
5. Edit properties in Inspector
6. Save (Ctrl+S)

#### Method 2: Through Script
```gdscript
# Create and save a TileColorMap
func create_default_colors():
    var color_map = TileColorMap.new()
    color_map.set_color("forest", Color("#FFD700"))
    color_map.set_color("jungle", Color("#CCCCCC"))
    color_map.set_color("volcano", Color("#FF5C5C"))
    
    ResourceSaver.save(color_map, "res://config/tile_colors.tres")
```

#### Method 3: Export and Create
```gdscript
@tool
extends EditorScript

func _run():
    # Run this from the Script Editor
    var color_map = TileColorMap.new()
    # ... configure it ...
    ResourceSaver.save(color_map, "res://config/my_colors.tres")
    print("Resource created!")
```

### 4. Updating Board Configuration

#### Before
```gdscript
@export var color_map_file: String = "res://config/tile_colors.json"

func _ready():
    _load_color_map()
```

#### After
```gdscript
@export var color_map: TileColorMap = preload("res://config/tile_colors.tres")

func _ready():
    # color_map is already loaded and ready to use!
    var color = color_map.get_color("forest")
```

### 5. Batch Conversion Script

Create a tool script to convert all JSON files at once:

```gdscript
@tool
extends EditorScript

func _run():
    convert_color_maps()
    print("All conversions complete!")

func convert_color_maps():
    var json_files = [
        "res://config/tile_colors.json",
        # Add more files here
    ]
    
    for json_path in json_files:
        if not FileAccess.file_exists(json_path):
            continue
            
        var f = FileAccess.open(json_path, FileAccess.READ)
        if not f:
            continue
            
        var text = f.get_as_text()
        f.close()
        
        var json = JSON.parse_string(text)
        if json == null:
            print("Failed to parse: ", json_path)
            continue
        
        var color_map = TileColorMap.from_json(json)
        var tres_path = json_path.replace(".json", ".tres")
        
        var err = ResourceSaver.save(color_map, tres_path)
        if err == OK:
            print("Converted: ", json_path, " -> ", tres_path)
        else:
            print("Failed to save: ", tres_path)
```

## Migration Checklist

### Phase 1: Setup (No Breaking Changes)
- [ ] Create new Resource classes (TileData, TileColorMap, etc.)
- [ ] Add ColorUtils utility class
- [ ] Test new classes with examples
- [ ] Create example .tres files

### Phase 2: Parallel Support (Backwards Compatible)
- [ ] Add Resource-based exports to existing scripts
- [ ] Keep JSON loading as fallback
- [ ] Update documentation
- [ ] Create migration scripts

### Phase 3: Gradual Migration
- [ ] Convert one JSON file to .tres
- [ ] Test thoroughly
- [ ] Convert remaining files
- [ ] Update all references
- [ ] Keep JSON files for now (backup)

### Phase 4: Cleanup (Optional)
- [ ] Mark JSON loading as deprecated
- [ ] Remove old JSON files
- [ ] Remove JSON loading code
- [ ] Update all tutorials and examples

## Common Issues and Solutions

### Issue 1: "Resource not found"
**Problem**: Trying to preload a .tres that doesn't exist yet

**Solution**: Create the resource first or use load() with error checking
```gdscript
var color_map = load("res://config/tile_colors.tres")
if color_map == null:
    color_map = TileColorMap.new()
```

### Issue 2: "Property not found"
**Problem**: Trying to access old JSON property names

**Solution**: Update property names to match Resource class
```gdscript
# Before
var color = color_dict["forest"]

# After
var color = color_map.get_color("forest")
```

### Issue 3: "Can't save resource"
**Problem**: ResourceSaver.save() fails

**Solution**: Check file path and permissions
```gdscript
var err = ResourceSaver.save(resource, path)
if err != OK:
    push_error("Failed to save resource: " + error_string(err))
```

### Issue 4: "Changes not reflected in editor"
**Problem**: Modified resource in code but editor doesn't show changes

**Solution**: Use `notify_property_list_changed()` or restart editor
```gdscript
@tool
extends Resource

func set_color(tile_type: String, color: Color):
    mappings[tile_type] = color
    if Engine.is_editor_hint():
        notify_property_list_changed()
```

## Best Practices

### 1. Use Preload for Static Resources
```gdscript
# Good - loaded at compile time
@export var colors: TileColorMap = preload("res://config/tile_colors.tres")

# Avoid - loaded at runtime
var colors = load("res://config/tile_colors.tres")
```

### 2. Create Resource Libraries
```gdscript
# config/tile_library.gd
class_name TileLibrary
extends Resource

@export var forest_tile: TileData
@export var volcano_tile: TileData
@export var boss_tile: TileData
# ... etc
```

### 3. Use Resource as Export
```gdscript
# Allows inspector drop-down selection
@export var tile_data: TileData
```

### 4. Organize Resources
```
config/
├── colors/
│   ├── default_colors.tres
│   ├── night_colors.tres
│   └── desert_colors.tres
├── tiles/
│   ├── boss.tres
│   ├── treasure.tres
│   └── shop.tres
└── maps/
    ├── level_1.tres
    └── level_2.tres
```

## Testing Your Migration

### 1. Unit Test Resources
```gdscript
func test_color_map():
    var map = TileColorMap.new()
    map.set_color("test", Color.RED)
    assert_eq(map.get_color("test"), Color.RED)
    assert_true(map.has_color("test"))
```

### 2. Compare JSON vs Resource
```gdscript
func test_json_vs_resource():
    var json_colors = load_from_json("res://config/tile_colors.json")
    var res_colors = preload("res://config/tile_colors.tres")
    
    for key in json_colors:
        var json_color = ColorUtils.hex_to_color(json_colors[key])
        var res_color = res_colors.get_color(key)
        assert_eq(json_color, res_color, "Color mismatch for: " + key)
```

### 3. Performance Comparison
```gdscript
func benchmark_loading():
    var start = Time.get_ticks_usec()
    for i in range(1000):
        load_from_json("res://config/tile_colors.json")
    var json_time = Time.get_ticks_usec() - start
    
    start = Time.get_ticks_usec()
    for i in range(1000):
        preload("res://config/tile_colors.tres")
    var res_time = Time.get_ticks_usec() - start
    
    print("JSON: ", json_time, "μs")
    print("Resource: ", res_time, "μs")
    print("Speedup: ", float(json_time) / res_time, "x")
```

## Support and Troubleshooting

If you encounter issues:
1. Check the examples/ folder for working code
2. Review docs/CODE_IMPROVEMENTS.md
3. Ensure all Resource classes are in the project
4. Verify file paths are correct
5. Check Godot console for errors

## Next Steps

After migration:
1. Explore creating custom EditorInspectorPlugins for resources
2. Add resource preview thumbnails
3. Create resource import plugins if needed
4. Consider resource pools for frequently used resources

## Conclusion

Migrating to Resources provides better editor integration and performance. Take it step by step, test thoroughly, and enjoy the improved workflow!
