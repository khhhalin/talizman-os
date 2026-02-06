# Character Selection System

## Overview
Players must select characters before the game begins. This ensures everyone has chosen their adventurer before stepping onto the board.

## Flow

```
Lobby → Click "Single Player" or "Host"/"Start" 
     → Character Selection Screen
     → All players select characters
     → Start button becomes enabled
     → Game begins
```

## Characters Available (Simple Version)

### 1. Warrior
- **Strength**: 5
- **Craft**: 2
- **Life**: 5
- **Fate**: 2
- **Role**: Tank, high combat

### 2. Wizard
- **Strength**: 2
- **Craft**: 5
- **Life**: 4
- **Fate**: 3
- **Role**: Magic user, spell caster

### 3. Assassin
- **Strength**: 4
- **Craft**: 3
- **Life**: 4
- **Fate**: 3
- **Role**: Balanced, versatile

### 4. Priest
- **Strength**: 3
- **Craft**: 4
- **Life**: 4
- **Fate**: 3
- **Role**: Support, healing

### 5. Elf
- **Strength**: 3
- **Craft**: 3
- **Life**: 4
- **Fate**: 4
- **Role**: Balanced, lucky

### 6. Dwarf
- **Strength**: 4
- **Craft**: 2
- **Life**: 5
- **Fate**: 2
- **Role**: Tough, sturdy

## Rules

1. **Each character can only be selected once**
2. **All players must select before game starts**
3. **Bots auto-select random available characters**
4. **Start button disabled until all selected**

## Single Player Mode

- Player selects their character
- Bot(s) automatically select from remaining characters
- Once player selects, all slots fill immediately
- Start button enables

## Multiplayer Mode (Future)

- Each player selects their own character
- See what others have selected
- Cannot pick already-selected characters
- Host clicks Start when everyone ready

## UI Layout

```
┌─────────────────────────────────────────────┐
│     SELECT YOUR CHARACTER                   │
├──────────────────┬──────────────────────────┤
│ Available:       │ Player Status:           │
│                  │                          │
│ • Warrior        │ You: [Select]           │
│ • Wizard         │ Bot 1: Waiting...       │
│ • Assassin       │                          │
│ • Priest         │                          │
│ • Elf            │                          │
│ • Dwarf          │                          │
│                  │                          │
├──────────────────┴──────────────────────────┤
│  [Back to Lobby]      [START GAME]          │
└─────────────────────────────────────────────┘
```

## Code Structure

### Simple Implementation (Current)

```gdscript
# Character data
const CHARACTERS = [
    {"name": "Warrior", "strength": 5, ...},
    # etc
]

# Track selections
var player_selections: Dictionary = {}  # player_id -> character_name

# Check if all ready
func _check_all_selected() -> bool:
    return player_selections.size() == required_count
```

### Future: Draft Modes

Later we'll add different selection methods:
- **Random Draft**: Characters assigned randomly
- **Snake Draft**: Pick order reverses each round
- **Auction Draft**: Bid on characters
- **Preset Teams**: Pre-made character groups

But for now: **Simple pick from list!**

## How It Works

1. **Player clicks character** from list
2. **Character marked as selected**
3. **Bots auto-select** (if single player)
4. **UI updates** to show selections
5. **Start button enables** when all ready
6. **Click Start** → Game begins with chosen characters

## Data Storage

Selected characters stored in `Gamestate`:
```gdscript
Gamestate.set_meta("character_selections", player_selections)
Gamestate.set_meta("characters_data", CHARACTERS)
```

Gameplay scene retrieves them:
```gdscript
var selections = Gamestate.get_meta("character_selections")
```

## Future Enhancements

- [ ] Character portraits/artwork
- [ ] Stat comparisons
- [ ] Character abilities display
- [ ] Random selection button
- [ ] Favorite character marking
- [ ] Draft mode selection
- [ ] Time limit for selection
- [ ] Ready check system

## Testing

### Single Player Test
1. Lobby → Single Player
2. Character select appears
3. Click any character
4. See "You: [Character]" and "Bot 1: [Auto-selected]"
5. Start button enables
6. Click Start → Gameplay

### Multiplayer Test (When Implemented)
1. Host game
2. Players join
3. Host clicks Start
4. All go to character select
5. Each picks character
6. Last to pick enables Start
7. Host starts game

## Caesar's Decree

This is the **simple version** as commanded!
- Pick character from list ✅
- Bots auto-select ✅
- Everyone must select ✅
- Clean, simple code ✅

Fancy draft modes come later, after the demo works! 🎲
