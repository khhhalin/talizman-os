class_name PlayerToken
extends Node2D

## Player token on the board
## Simple visual representation of a player character

signal token_clicked(token: PlayerToken)

@export var player_id: int = 1
@export var character_name: String = "Warrior"
@export var player_name: String = "Player 1"
@export var token_color: Color = Color.RED
@export var token_size: float = 15.0  # Smaller than tiles!

var current_tile_index: int = 0  # Which tile the token is on
var is_current_player: bool = false

@onready var sprite = $Sprite
@onready var character_label = $CharacterLabel
@onready var player_label = $PlayerLabel
@onready var highlight = $Highlight

func _ready() -> void:
	_update_visuals()

func setup(p_player_id: int, p_character_name: String, p_player_name: String, p_color: Color, start_tile: int = 0) -> void:
	"""Initialize the token with player data"""
	player_id = p_player_id
	character_name = p_character_name
	player_name = p_player_name
	token_color = p_color
	current_tile_index = start_tile
	_update_visuals()

func _update_visuals() -> void:
	"""Update the token appearance"""
	# Draw colored circle
	if sprite:
		sprite.modulate = token_color
	
	# Show character name
	if character_label:
		character_label.text = character_name
	
	# Show player name
	if player_label:
		player_label.text = player_name
	
	# Show highlight if current player
	if highlight:
		highlight.visible = is_current_player

func _draw() -> void:
	# Draw simple circle as token (smaller than tiles!)
	draw_circle(Vector2.ZERO, token_size, token_color)
	# Border
	draw_arc(Vector2.ZERO, token_size, 0, TAU, 32, Color.BLACK, 1.5)

func set_current_player(is_current: bool) -> void:
	"""Mark this token as the current player"""
	is_current_player = is_current
	_update_visuals()
	queue_redraw()

func move_to_tile(tile_index: int) -> void:
	"""Move token to a specific tile"""
	current_tile_index = tile_index

func get_tile_index() -> int:
	"""Get current tile position"""
	return current_tile_index

## Input handling
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			token_clicked.emit(self)
