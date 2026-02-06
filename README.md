# Talizman OS - Digital Talisman Board Game

A FOSS digital implementation of the Talisman board game, built with Godot 4.6.

## About

Talisman is a classic fantasy adventure board game where players compete to reach the Crown of Command at the center of the board. This digital edition recreates the experience in Godot, featuring:

- **Three-region board**: Outer, Middle, and Inner regions
- **Character progression**: Gain Strength, Craft, and items
- **Encounter system**: Draw cards and face challenges
- **Multiplayer ready**: Play locally or online
- **FOSS**: Completely free and open source

## Features

- **Data-driven board system**: Define board layout in JSON
- **Visual tile system**: Color-coded spaces with names
- **Region-based layout**: Three concentric regions like original game
- **Scene management**: Clean navigation between menus and game
- **Modular architecture**: Easy to extend and customize
- **Godot Resources**: Type-safe configuration system

## Getting Started

### Quick Play

1. Open project in Godot 4.6+
2. Press **F5** to run
3. Click **Play** from main menu
4. Choose your mode:
   - **Single Player** - Play solo (demo mode)
   - **Host** - Host a multiplayer game
   - **Join** - Join someone else's game
5. **Select Your Character**:
   - Choose from Warrior, Wizard, Assassin, Priest, Elf, or Dwarf
   - Bots automatically select from remaining characters
   - Click **Start Game** when ready
6. View the Talisman board with three regions
7. Click **Back to Menu** to return

### Understanding the Board

The board has three regions:
- **Outer Region** (Green): 12 spaces for beginners (Fields, Woods, City, etc.)
- **Middle Region** (Brown/Gray): 6 harder spaces (Mountains, Castle, etc.)
- **Inner Region** (Purple): 2 end-game spaces (Inner Region, Crown of Command)

### Creating a Board

#### Using Resources (Recommended)
```gdscript
@export var color_map: TileColorMap = preload("res://config/tile_colors.tres")
```

#### Using JSON (Legacy)
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

## Current Demo Status

### Implemented ✅
- Three-region Talisman board (Outer, Middle, Inner)
- 20 unique spaces with Talisman-themed names
- Visual board display with color-coded regions
- Main menu system
- Gameplay scene with camera
- Scene navigation (Menu ↔ Game)
- Clean architecture with Resources

### In Development 🔄
- Character tokens and selection
- Dice rolling and movement
- Turn-based gameplay
- Encounter cards
- Combat system
- Item/spell inventory

### Planned ⏳
- Multiple playable characters
- Full encounter deck
- Special space effects (City, Tavern, etc.)
- Win condition (Crown of Command)
- Multiplayer support
- AI opponents
- Save/load system

## Technical Improvements

### Code Quality
- ✅ Fixed all compilation errors
- ✅ Proper scene structure (Gameplay scene)
- ✅ Godot Resource support
- ✅ No hard-coded dependencies
- ✅ Comprehensive documentation

### Architecture
- ✅ Modular board system
- ✅ Scene manager for navigation
- ✅ Autoload singletons for state
- ✅ Resource-based configuration
- ✅ Backwards compatible JSON support

## What is Talisman?

Talisman is a fantasy adventure board game where 2-6 players compete to:
1. **Explore** the three regions of the board
2. **Battle** monsters and overcome challenges
3. **Gain** strength, items, and experience
4. **Reach** the Crown of Command at the center
5. **Defeat** all other players to win

Each turn, players:
- Roll a die to move
- Land on a space
- Draw an encounter card
- Resolve the encounter (fight, event, treasure, etc.)
- Gain or lose stats/items

The journey progresses from the safe Outer Region, through the dangerous Middle Region, to the deadly Inner Region where only one can claim victory!

## Documentation

- [Talisman Game Design](docs/TALISMAN_GAME_DESIGN.md) - **START HERE** - Complete game design document
- [Developer Guide](docs/DEVELOPER.md) - Technical architecture
- [Map Format](docs/MAP_FORMAT.md) - JSON board definition
- [Code Improvements](docs/CODE_IMPROVEMENTS.md) - Best practices
- [Migration Guide](docs/MIGRATION_GUIDE.md) - Moving to Resources
- [Quick Start](QUICKSTART.md) - Get running in 5 minutes

## Architecture

```
game/
├── board/              # Board system (tiles, builders, validators)
├── autoloads/          # Global managers (Gamestate, SceneManager, KeyPersistence)
├── main_menu/          # Main menu scene
├── lobby_manager/      # Multiplayer lobby
└── options_menu/       # Settings and key remapping

config/                 # Configuration files (JSON and .tres)
tests/                  # Unit tests
tools/                  # Development utilities
addons/                 # Editor plugins
```

## Key Components

### Board System
- **Board.gd**: Main board node, manages tiles and layout
- **Tile.gd**: Individual tile with visual properties
- **BoardBuilder.gd**: Constructs board from data
- **BoardDataLoader.gd**: Loads and parses map files
- **MapValidator.gd**: Validates map structure
- **RegionParser.gd**: Parses flexible region definitions

### Resources
- **TileData**: Tile configuration resource
- **TileColorMap**: Color mapping resource
- **BoardMapData**: Map structure resource (future)

### Utilities
- **ColorUtils**: Color conversion helpers
- **SceneManager**: Scene navigation
- **Gamestate**: Multiplayer state management

## Testing

Run tests from the editor:
1. Open test file (e.g., `tests/test_validator.gd`)
2. Run scene
3. Check Output console

## Multiplayer

### Hosting
1. Click "Host" in lobby
2. Share your IP address with players
3. Wait for players to join
4. Click "Start" to begin

### Joining
1. Click "Join" in lobby
2. Enter host IP address
3. Wait for host to start game

## Contributing

When contributing:
- Follow GDScript style guide
- Use tabs for indentation
- Add doc comments for public APIs
- Write tests for new features
- Update documentation

## Language & Renderer

- Language: GDScript
- Renderer: Compatibility
- Engine: Godot 4.6

## License

[Add your license here]

## Credits

Based on the Multiplayer Bomber demo from Godot Asset Library.
