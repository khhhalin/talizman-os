class_name DiceRoller
extends Control

## DiceRoller UI Component
## Displays dice and allows rolling
## Extensible for multiple dice per player later

signal roll_completed(result: int)

@export var dice: Dice  # The die to roll (can be per-player later)

@onready var roll_button = $VBox/RollButton
@onready var result_label = $VBox/ResultLabel
@onready var dice_display = $VBox/DiceDisplay

var is_rolling: bool = false
var current_result: int = 0

func _ready() -> void:
	# Create default dice if none assigned
	if not dice:
		dice = Dice.new(6)
	
	# Connect signals
	if roll_button:
		roll_button.pressed.connect(_on_roll_button_pressed)
	
	dice.rolled.connect(_on_dice_rolled)
	
	_update_display()

func _on_roll_button_pressed() -> void:
	if is_rolling:
		return
	
	# Disable button during roll
	roll_button.disabled = true
	is_rolling = true
	
	# Animate roll (simple for now)
	_animate_roll()

func _animate_roll() -> void:
	# Simple animation: show random numbers quickly
	var animation_time = 0.5  # seconds
	var updates = 10
	var delay = animation_time / updates
	
	for i in range(updates):
		dice_display.text = str(randi_range(1, dice.sides))
		await get_tree().create_timer(delay).timeout
	
	# Final roll
	current_result = dice.roll()
	_update_display()
	
	# Re-enable button
	is_rolling = false
	roll_button.disabled = false
	
	# Emit completion
	roll_completed.emit(current_result)

func _on_dice_rolled(result: int) -> void:
	current_result = result
	_update_display()

func _update_display() -> void:
	if current_result > 0:
		dice_display.text = str(current_result)
		result_label.text = "Rolled: %d" % current_result
	else:
		dice_display.text = "?"
		result_label.text = "Ready to roll"

## Set which die to use (for per-player dice later)
func set_dice(new_dice: Dice) -> void:
	if dice and dice.rolled.is_connected(_on_dice_rolled):
		dice.rolled.disconnect(_on_dice_rolled)
	
	dice = new_dice
	dice.rolled.connect(_on_dice_rolled)
	current_result = 0
	_update_display()

## Get last roll result
func get_last_roll() -> int:
	return current_result

## Show/hide dice roller
func set_visible_custom(visible: bool) -> void:
	self.visible = visible
