# Quick Start Guide - Talizman OS

## Getting Started in 5 Minutes

### 1. Open the Project
- Launch Godot 4.6+
- Open this project folder
- Wait for initial import (first time only)

### 2. Run the Game
- Press **F5** or click the **Play** button
- Main menu should appear
- Choose **Play** → **Host** to start a local game
- Or **Join** to connect to another player

### 3. Explore the Board System
- Open `game/board/board.tscn` in the editor
- Select the Board node
- Check the Inspector for configuration options
- Try changing `rows`, `cols`, or `tile_size`

## Creating Your First Board

### Option 1: Using the Visual Editor (Recommended)

1. **Create a new scene**
   - Scene → New Scene
   - Add Node2D as root
   - Save as `my_board.tscn`

2. **Add a Board node**
   - Add Child Node → search "Board"
   - Or add Node2D and attach `board.gd` script

3. **Configure in Inspector**
   ```
   Rows: 8
   Cols: 8
   Tile Size: (32, 32)
   Color Map: (drag tile_colors.tres)
   ```

4. **Run the scene** (F6)
   - Board should generate automatically!

### Option 2: Using JSON (Legacy)

1. **Create a map file** in `config/`
   ```json
   {
     "nodes": [
       {"id": "A", "x": 0, "y": 0, "tile": "start"},
       {"id": "B", "x": 1, "y": 0, "tile": "rest"}
     ],
     "edges": [
       {"from": "A", "to": "B", "directed": false}
     ]
   }
   ```

2. **Reference in Board**
   ```gdscript
   Map Path: res://config/my_map.json
   Auto Build On Ready: true
   ```

3. **Run the scene** (F6)

### Option 3: Using Resources (New!)

1. **Create a TileColorMap**
   - Right-click in FileSystem
   - New Resource → TileColorMap
   - Edit colors in Inspector
   - Save as `my_colors.tres`

2. **Use in Board**
   ```gdscript
   @export var color_map: TileColorMap = preload("res://config/my_colors.tres")
   ```

## Common Tasks

### Change Tile Colors

**Visual Method:**
1. Open `config/tile_colors.tres`
2. Expand "Mappings" in Inspector
3. Click color to open color picker
4. Save (Ctrl+S)

**Code Method:**
```gdscript
var color_map = TileColorMap.new()
color_map.set_color("forest", Color.GREEN)
color_map.set_color("volcano", Color.RED)
```

### Add Custom Tile Types

1. **Edit ColorUtils or TileColorMap**
   ```gdscript
   color_map.set_color("my_custom_tile", Color.PURPLE)
   ```

2. **Use in map JSON**
   ```json
   {"id": "X", "tile": "my_custom_tile"}
   ```

### Connect Tiles with Edges

**Undirected (both ways):**
```json
{"from": "A", "to": "B", "directed": false}
```

**Directed (one way):**
```json
{"from": "A", "to": "B", "directed": true}
```

**Using Regions (shorthand):**
```json
{
  "MyRegion": {
    "two way": [["A", "B", "C"]],
    "one way": [{"C": "A"}]
  }
}
```

## Testing Your Changes

### Run Unit Tests
1. Open `tests/test_validator.gd`
2. Click **Run Current Script** (or add to scene and F6)
3. Check Output console for results

### Test in Editor
1. Select Board node
2. Enable "Board Tools" plugin in Project Settings
3. Click "Rebuild from Map" in Inspector
4. Toggle "Visualize Edges" to see connections

## Troubleshooting

### Board Doesn't Appear
- Check "Auto Build On Ready" is enabled
- Verify map_path points to valid file
- Check Output console for errors

### Colors Wrong
- Verify color_map_file or color_map resource
- Check tile type names match color map keys
- Try reloading the project (Project → Reload)

### JSON Parse Error
- Validate JSON with online tool
- Check for typos in node IDs
- Ensure all edges reference existing nodes

### Performance Issues
- Reduce rows × cols
- Use Object Pooling (see docs)
- Disable edge visualization

## Next Steps

### Learn More
- 📖 [Developer Guide](docs/DEVELOPER.md) - Architecture details
- 🎓 [Migration Guide](docs/MIGRATION_GUIDE.md) - Moving to Resources
- 💡 [Code Improvements](docs/CODE_IMPROVEMENTS.md) - Best practices
- 🔧 [Refactoring Summary](docs/REFACTORING_SUMMARY.md) - Recent changes

### Explore Examples
- `examples/example_resource_usage.gd` - Code examples
- `tests/` - Unit tests showing usage

### Try Advanced Features
- Create custom tile scenes
- Implement board navigation
- Add animations to tiles
- Create multiplayer boards

## Useful Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Run Project | F5 |
| Run Current Scene | F6 |
| Reload Project | Ctrl+Alt+R |
| Save Scene | Ctrl+S |
| Open Script | Ctrl+Alt+O |
| Search Files | Ctrl+Shift+F |

## Quick Reference

### Board Properties
```gdscript
rows: int                     # Number of rows
cols: int                     # Number of columns
tile_size: Vector2            # Size of each tile
spacing: Vector2              # Space between tiles
tile_scene: PackedScene       # Custom tile scene
color_map: TileColorMap       # Color mappings
map_path: String              # JSON map file
auto_build_on_ready: bool     # Auto-generate on load
```

### Tile Properties
```gdscript
tile_name: String             # Tile type name
color: Color                  # Base color
spot_scale: float             # Spot marker size (0-1)
spot_color: Color             # Spot marker color
shape: Shape                  # RECTANGLE or CIRCLE
filled: bool                  # Draw filled or outline
```

### Key Classes
- **Board** - Main board manager
- **Tile** - Individual tile node
- **TileColorMap** - Color configuration resource
- **TileData** - Tile properties resource
- **BoardBuilder** - Constructs boards from data
- **ColorUtils** - Color conversion utilities

## Getting Help

1. Check the documentation in `docs/`
2. Review example code in `examples/`
3. Look at test files in `tests/`
4. Check Godot console for error messages
5. Verify you're using Godot 4.6+

## Have Fun! 🎮

Experiment, break things, learn, and create amazing boards!

---

**Pro Tip:** Start simple with auto-generated grids, then move to JSON maps, then finally use Resources for production.
