# Dice System - Extensible Design

## Overview
Caesar commanded an extensible dice system! This design supports:
- ✅ Simple dice rolling for demo
- ✅ Per-player dice (later)
- ✅ Luck tracking based on roll history
- ✅ Statistics and analytics

## Architecture

### Dice Resource (`Dice.gd`)
The core dice class - extensible for future features.

```gdscript
class_name Dice
extends Resource

@export var sides: int = 6           # Number of sides
@export var owner_id: int = -1       # Which player owns this
@export var color: Color = Color.WHITE  # Visual customization

# Statistics (extensible)
var roll_history: Array[int] = []    # Last 100 rolls
var total_rolls: int = 0
var sum_of_rolls: int = 0
var luck_score: float = 0.0          # Luck tracking
```

### DiceRoller UI (`DiceRoller.gd`)
Visual component for rolling dice.

```gdscript
class_name DiceRoller
extends Control

signal roll_completed(result: int)

@export var dice: Dice  # Which die to roll

# Simple animation
func _animate_roll() -> void:
    # Show random numbers quickly
    # Then final result
```

## Current Demo Implementation

### Simple Version
- One shared die for all players
- Roll 1-6
- Show result
- Basic animation

```gdscript
# In gameplay.gd
var die = Dice.new(6)
dice_roller.set_dice(die)

# Player rolls
var result = die.roll()  # Returns 1-6
```

## Future Extensibility

### Per-Player Dice (Later)
Each player will have their own die with tracked luck!

```gdscript
# Create dice for each player
var player_dice: Dictionary = {}

for player_id in players:
    var die = Dice.new(6, player_id)
    die.color = player_colors[player_id]
    player_dice[player_id] = die

# Switch to current player's die
dice_roller.set_dice(player_dice[current_player_id])
```

### Luck Tracking System (Later)

#### How Luck Works
```gdscript
# After many rolls, calculate if die is lucky
func _calculate_luck() -> void:
    var average = sum_of_rolls / total_rolls
    var expected = (sides + 1) / 2.0  # For d6: 3.5
    
    # Positive = lucky, negative = unlucky
    luck_score = average - expected
```

#### Luck Examples
- **Lucky Die**: Average 4.2 on d6 → luck_score = +0.7
- **Normal Die**: Average 3.5 on d6 → luck_score = 0.0
- **Unlucky Die**: Average 2.8 on d6 → luck_score = -0.7

#### Visual Indicators (Future)
```gdscript
# Show die color based on luck
if luck_score > 0.5:
    die.color = Color.GOLD      # Very lucky!
elif luck_score > 0.2:
    die.color = Color.GREEN     # Lucky
elif luck_score < -0.5:
    die.color = Color.DARK_RED  # Very unlucky!
elif luck_score < -0.2:
    die.color = Color.RED       # Unlucky
else:
    die.color = Color.WHITE     # Normal
```

### Statistics Display (Future)

```gdscript
# Get die statistics
var stats = die.get_stats()
# Returns:
# {
#   "total_rolls": 50,
#   "average": 3.8,
#   "luck_score": 0.3,
#   "history": [3, 5, 2, 6, ...]
# }

# Display in UI
stats_label.text = """
Total Rolls: %d
Average: %.1f
Luck: %s
""" % [stats.total_rolls, stats.average, _get_luck_text(stats.luck_score)]
```

### Dice Customization (Future)

```gdscript
# Different dice per player
class_name PlayerDice extends Dice

@export var player_name: String
@export var custom_texture: Texture2D
@export var roll_sound: AudioStream

# Special abilities per die
@export var abilities: Array[String] = []

# Example abilities:
# - "Reroll once per turn"
# - "Add +1 on rolls of 1"
# - "Double on 6s"
```

## File Structure

```
game/dice/
├── Dice.gd           # Core dice resource (extensible)
├── DiceRoller.gd     # UI component
└── DiceRoller.tscn   # Visual layout

game/gameplay/
└── gameplay.gd       # Uses dice system
```

## How It's Used

### Demo (Current)
```gdscript
# 1. Create die
var die = Dice.new(6)

# 2. Assign to roller
dice_roller.set_dice(die)

# 3. Player clicks "Roll"
# 4. Animation plays
# 5. Result shown: 1-6
# 6. Statistics tracked silently
```

### Future (With Luck)
```gdscript
# 1. Each player has own die
var my_die = player_dice[my_id]

# 2. Check die's luck
if my_die.luck_score > 0.5:
    print("Your die is lucky!")

# 3. Display stats
ui.show_die_stats(my_die.get_stats())

# 4. Swap between player dice
dice_roller.set_dice(player_dice[current_player])
```

## Extensibility Examples

### Example 1: Lucky Die Bonus (Future)
```gdscript
# Modify roll based on luck
func roll_with_luck() -> int:
    var base_roll = roll()
    
    # Very lucky die: chance for +1
    if luck_score > 0.5 and randf() < 0.2:
        print("Lucky bonus!")
        return mini(base_roll + 1, sides)
    
    # Very unlucky die: chance for -1
    if luck_score < -0.5 and randf() < 0.2:
        print("Unlucky penalty!")
        return maxi(base_roll - 1, 1)
    
    return base_roll
```

### Example 2: Dice Achievements (Future)
```gdscript
# Track special roll patterns
func check_achievements() -> void:
    # "Lucky streak" - 3 sixes in a row
    if roll_history[-3:] == [6, 6, 6]:
        award_achievement("Lucky Streak")
    
    # "Snake eyes" - rolled 1 three times
    if roll_history.count(1) >= 3:
        award_achievement("Snake Eyes")
```

### Example 3: Dice Trading (Future)
```gdscript
# Players can trade dice
func trade_dice(from_player: int, to_player: int) -> void:
    var temp = player_dice[from_player]
    player_dice[from_player] = player_dice[to_player]
    player_dice[to_player] = temp
```

### Example 4: Loaded Dice (Future)
```gdscript
# Special dice with weighted rolls
class_name LoadedDice extends Dice

@export var weights: Array[float] = [1.0, 1.0, 1.0, 1.0, 1.0, 2.0]  # 6 is 2x likely

func roll() -> int:
    var total_weight = 0.0
    for w in weights:
        total_weight += w
    
    var rand = randf() * total_weight
    var cumulative = 0.0
    
    for i in range(sides):
        cumulative += weights[i]
        if rand <= cumulative:
            var result = i + 1
            _record_roll(result)
            return result
    
    return sides  # Fallback
```

## Integration Points

### With Character System
```gdscript
# Each character might affect their die
func apply_character_bonus(character_name: String) -> void:
    match character_name:
        "Wizard":
            # Wizard's die is slightly luckier
            luck_score += 0.1
        "Dwarf":
            # Dwarf's die is more consistent
            # (reduce variance in rolls)
            pass
```

### With Movement System (Next)
```gdscript
# Roll die, then move that many spaces
func _on_dice_rolled(result: int) -> void:
    move_player(current_player, result)
```

### With Items (Later)
```gdscript
# Items can modify dice
class DiceModifierItem:
    @export var roll_bonus: int = 0      # Add to roll
    @export var reroll_chance: float = 0.0  # Chance to reroll
    
    func apply(die: Dice, result: int) -> int:
        return result + roll_bonus
```

## Statistics Storage

### Save Dice Data (Future)
```gdscript
# Save dice stats to file
func save_dice() -> void:
    var save_data = {
        "player_dice": {},
    }
    
    for player_id in player_dice:
        save_data.player_dice[player_id] = {
            "stats": player_dice[player_id].get_stats(),
            "color": player_dice[player_id].color,
        }
    
    var file = FileAccess.open("user://dice_data.save", FileAccess.WRITE)
    file.store_var(save_data)
```

## UI Enhancements (Future)

### Advanced Dice Display
```
┌────────────────┐
│   🎲 DIE #1    │
│                │
│     [6]        │  ← Big result
│                │
│ Rolls: 42      │
│ Avg: 3.8       │
│ Luck: +0.3 ⭐  │  ← Luck indicator
│                │
│ [Roll Again]   │
└────────────────┘
```

### Dice Collection (Future)
```gdscript
# Players collect different dice
var dice_inventory: Array[Dice] = []

# Use special dice for different situations
func select_die_for_combat() -> Dice:
    # Pick die with highest luck for important rolls
    var best_die = dice_inventory[0]
    for die in dice_inventory:
        if die.luck_score > best_die.luck_score:
            best_die = die
    return best_die
```

## Testing

### Current Testing
```gdscript
# Test basic rolling
func test_roll():
    var die = Dice.new(6)
    for i in range(100):
        var result = die.roll()
        assert(result >= 1 and result <= 6)
    
    var stats = die.get_stats()
    print("After 100 rolls:")
    print("Average: ", stats.average)
    print("Luck: ", stats.luck_score)
```

### Future Testing
```gdscript
# Test luck tracking
func test_luck_calculation():
    var die = Dice.new(6)
    
    # Simulate lucky rolls
    die._record_roll(6)
    die._record_roll(5)
    die._record_roll(6)
    # ... etc
    
    assert(die.luck_score > 0)  # Should be positive
```

## Caesar's Requirements ✅

- ✅ **Extensible**: Easy to add per-player dice
- ✅ **Luck Tracking**: Statistics recorded every roll
- ✅ **Simple Demo**: Works for basic gameplay now
- ✅ **Future-Proof**: Ready for advanced features
- ✅ **Clean Code**: Simple and understandable

## Summary

The dice system is **simple for the demo** but **ready for expansion**:

**Now**:
- Roll d6
- Show result
- Track stats silently

**Later** (When Caesar Commands):
- Per-player dice with colors
- Luck display and bonuses
- Dice customization
- Trading and collecting
- Special abilities
- Achievements

**All without rewriting the core system!** 🎲👑
