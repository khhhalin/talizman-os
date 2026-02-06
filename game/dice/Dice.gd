class_name Dice
extends Resource

## Dice Resource - Extensible for per-player dice with luck tracking
## Simple for demo, ready for future enhancements

signal rolled(result: int)

@export var sides: int = 6  # Standard d6 for now
@export var owner_id: int = -1  # Which player owns this die (for later)
@export var color: Color = Color.WHITE  # Visual customization (for later)

# Statistics tracking (for luck system later)
var roll_history: Array[int] = []
var total_rolls: int = 0
var sum_of_rolls: int = 0

# Luck tracking (for future implementation)
var luck_score: float = 0.0  # Will track if die is "lucky" or "unlucky"

func _init(p_sides: int = 6, p_owner_id: int = -1) -> void:
	sides = p_sides
	owner_id = p_owner_id

## Roll the die - returns result
func roll() -> int:
	var result = randi_range(1, sides)
	_record_roll(result)
	rolled.emit(result)
	return result

## Record roll for statistics (extensible for luck tracking)
func _record_roll(result: int) -> void:
	roll_history.append(result)
	total_rolls += 1
	sum_of_rolls += result
	
	# Keep only last 100 rolls for memory efficiency
	if roll_history.size() > 100:
		roll_history.pop_front()
	
	# Calculate luck (for future use)
	_calculate_luck()

## Calculate if this die is lucky or unlucky (for future)
func _calculate_luck() -> void:
	if total_rolls == 0:
		luck_score = 0.0
		return
	
	# Average roll vs expected average
	var average = float(sum_of_rolls) / float(total_rolls)
	var expected_average = float(sides + 1) / 2.0  # For d6: 3.5
	
	# Luck score: positive = lucky, negative = unlucky
	luck_score = average - expected_average

## Get statistics (for future UI display)
func get_stats() -> Dictionary:
	return {
		"total_rolls": total_rolls,
		"average": float(sum_of_rolls) / float(total_rolls) if total_rolls > 0 else 0.0,
		"luck_score": luck_score,
		"history": roll_history.duplicate()
	}

## Reset statistics (for new game)
func reset_stats() -> void:
	roll_history.clear()
	total_rolls = 0
	sum_of_rolls = 0
	luck_score = 0.0
