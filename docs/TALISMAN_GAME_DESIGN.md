# Talisman Digital Edition - Game Design

## Overview
This is a FOSS digital implementation of the Talisman board game in Godot 4.6.

## Game Structure

### Board Layout
The Talisman board consists of three concentric regions:

#### **Outer Region** (Beginner Area)
- 12 spaces in a loop
- Spaces: Fields, Hills, Woods, Plains, City, Tavern, Forest, Ruins, Graveyard, Chapel, Village, Blacksmith
- Players start here
- Easier encounters and rewards

#### **Middle Region** (Intermediate Area)
- 6 spaces in a loop
- Spaces: Crags, Mountains, Chasm, Temple, Valley, Castle
- Connected to Outer Region via City
- Harder encounters, better rewards
- Gateway to Inner Region via Castle

#### **Inner Region** (End Game)
- 2 spaces: Inner Region, Crown of Command
- Only accessible with a Talisman
- Final confrontation at Crown of Command

### Game Flow

1. **Setup**
   - Each player chooses a character
   - Place character tokens on start space
   - Shuffle encounter cards
   - Set up shop and purchase decks

2. **Turn Structure**
   - Roll movement die (1-6)
   - Move clockwise around current region
   - Draw encounter card for space
   - Resolve encounter
   - End turn

3. **Character Progression**
   - Gain Strength, Craft, Lives
   - Collect Objects, Followers, Spells
   - Increase gold
   - Gain experience

4. **Win Condition**
   - Reach Crown of Command with a Talisman
   - Defeat all other players using Command spell

## Current Demo Features

### Implemented
- ✅ Three-region board system
- ✅ Visual board with colored spaces
- ✅ Region-based layout (Outer, Middle, Inner)
- ✅ Scene management (Main Menu → Gameplay)
- ✅ Camera system for board viewing
- ✅ Back to menu navigation

### In Progress
- 🔄 Character selection
- 🔄 Movement system
- 🔄 Encounter system
- 🔄 Combat mechanics

### Planned
- ⏳ Character stats and inventory
- ⏳ Card system (Encounters, Spells, Objects)
- ⏳ Shop and purchase system
- ⏳ Turn-based gameplay
- ⏳ Multiplayer support
- ⏳ AI opponents
- ⏳ Save/Load game
- ⏳ Special abilities per character

## Technical Architecture

### Scenes
```
game/
├── main_menu/         # Main menu with Play, Options, Exit
├── gameplay/          # Main game scene
│   ├── gameplay.gd    # Game logic
│   └── gameplay.tscn  # Board, UI, camera
├── board/             # Board system
│   ├── board.gd       # Board builder
│   └── tile.gd        # Individual tile
└── autoloads/         # Global managers
    ├── Gamestate.gd   # Game state and multiplayer
    └── SceneManager.gd # Scene transitions
```

### Data Structure
```
config/
├── map_demo.json      # Board layout definition
└── tile_colors.json   # Tile color mapping
```

### Resources
```
game/board/resources/
├── TileData.gd        # Tile properties
├── TileColorMap.gd    # Color definitions
└── BoardMapData.gd    # Map structure
```

## Space Types

### Adventure Spaces
- **Fields**: Draw Adventure card
- **Woods**: Draw Adventure card, may encounter enemies
- **Ruins**: Draw Adventure card, more dangerous
- **Graveyard**: Draw Adventure card, undead encounters

### Special Spaces
- **City**: Purchase items, heal, access Middle Region
- **Tavern**: Drink and gain/lose stats
- **Chapel**: Pray for blessings
- **Village**: Rest and heal
- **Blacksmith**: Repair and purchase weapons
- **Castle**: Gateway to Inner Region (requires quest completion)
- **Crown of Command**: Final battle location

### Middle Region Spaces
- **Crags**: Difficult terrain
- **Mountains**: High risk, high reward
- **Chasm**: Cross or fall
- **Temple**: Mystical encounters
- **Valley**: Mixed encounters

## Character Stats

### Primary Attributes
- **Strength**: Physical combat ability
- **Craft**: Magic and mental challenges
- **Lives**: Health/revival counter
- **Gold**: Currency for purchases
- **Fate**: Reroll tokens

### Character Types (Planned)
1. **Warrior**: High Strength, low Craft
2. **Wizard**: High Craft, low Strength
3. **Assassin**: Balanced, special abilities
4. **Priest**: Healing and support
5. **Elf**: Balanced stats, forest bonuses
6. **Dwarf**: High Strength, mountain bonuses

## Encounter System (Planned)

### Encounter Types
1. **Enemy**: Combat encounter
2. **Event**: Story event with choices
3. **Stranger**: NPC interaction
4. **Object**: Find item
5. **Place**: Special location effect

### Combat Flow
1. Roll die + Strength vs Enemy Strength
2. Winner deals damage equal to difference
3. Defeated enemies may give rewards
4. Player death: lose life, return to start

## Items and Inventory (Planned)

### Item Categories
- **Weapons**: Increase Strength
- **Armor**: Provide protection
- **Magical Objects**: Special effects
- **Followers**: Companions with abilities
- **Spells**: Cast for various effects

### Inventory Limits
- Max Objects: 4-6 (character dependent)
- Max Followers: 2-3
- Max Spells: Unlimited (but must be able to cast)

## Multiplayer Features (Planned)

### Modes
1. **Local Multiplayer**: Hot-seat gameplay
2. **Online Multiplayer**: Via Godot networking
3. **AI Opponents**: Computer-controlled players

### Turn Order
- Clockwise from starting player
- Current player indicated visually
- Timer optional for competitive play

## Demo Roadmap

### Phase 1: Board & Navigation (Current)
- ✅ Display board
- ✅ Three regions
- ✅ Scene management
- 🔄 Camera controls (zoom, pan)

### Phase 2: Character & Movement
- Add character tokens
- Implement dice rolling
- Movement around board
- Space landing effects

### Phase 3: Basic Encounters
- Simple encounter deck
- Draw card on space
- Basic combat system
- Stat tracking

### Phase 4: Items & Progression
- Inventory system
- Purchase items in City
- Character progression
- Win condition (reach Crown)

### Phase 5: Full Gameplay
- All encounter types
- All special spaces
- Complete combat
- Multiplayer support

### Phase 6: Polish & Content
- Multiple characters
- More cards and encounters
- Sound and music
- UI improvements
- Tutorial

## How to Extend

### Adding New Spaces
1. Add space name to `map_demo.json`
2. Add color to `tile_colors.json`
3. Create encounter logic in gameplay code
4. Add artwork (optional)

### Adding Characters
1. Create Character resource class
2. Define stats and abilities
3. Create character selection UI
4. Implement special abilities

### Adding Encounters
1. Create Encounter resource class
2. Define encounter types
3. Implement resolution logic
4. Add to encounter deck

## Current Controls

### Keyboard
- **ESC**: Open menu / Back
- **Mouse**: Navigate UI
- **WASD/Arrows**: Pan camera (planned)
- **Mouse Wheel**: Zoom camera (planned)

### Gamepad
- **D-Pad**: Navigate UI
- **A/B**: Select/Cancel
- **Triggers**: Zoom (planned)

## Configuration

### Board Settings
Edit `game/board/board.gd`:
```gdscript
@export var tile_size: Vector2 = Vector2(32, 32)
@export var spacing: Vector2 = Vector2(0, 0)
@export var map_path: String = "res://config/map_demo.json"
```

### Game Rules
Edit `game/gameplay/gameplay.gd`:
```gdscript
const STARTING_LIVES = 4
const STARTING_GOLD = 1
const MAX_OBJECTS = 4
```

## Resources & References

### Original Game
- Talisman is a board game by Games Workshop
- This is a FOSS recreation, not affiliated

### Similar Digital Editions
- Talisman: Digital Edition (Steam)
- Board Game Arena implementations

### Development
- Built with Godot 4.6
- GDScript programming
- 2D graphics
- Multiplayer capable

## License & Legal

This is an educational FOSS project. Talisman is a trademark of Games Workshop. This implementation uses original artwork and code, inspired by but not copying the commercial version.

## Contributing

To contribute:
1. Follow Godot/GDScript conventions
2. Document new features
3. Test thoroughly
4. Submit pull requests

## Support

- Check documentation in `docs/`
- Review code examples
- Test in Godot 4.6+
- Report issues clearly
