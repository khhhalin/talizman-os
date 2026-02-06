extends Node2D

## Gameplay scene for Talisman board game
## Manages the game board, players, and UI

@onready var board = $Board
@onready var back_button = $UI/BackButton
@onready var dice_roller = $UI/DiceRoller
@onready var tokens_container = $Tokens

# Player data
var player_dice: Dictionary = {}  # player_id -> Dice
var player_tokens: Dictionary = {}  # player_id -> PlayerToken
var player_characters: Dictionary = {}  # player_id -> character_name
var current_player_id: int = 1

# Token scene
const TOKEN_SCENE = preload("res://game/player_token/player_token.tscn")

# Player colors (simple for now)
const PLAYER_COLORS = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.PURPLE,
	Color.ORANGE
]

func _ready() -> void:
	# Connect back button
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	
	# Set up camera to center on board
	var camera = $Camera2D
	if camera and board:
		# Center camera on board center
		camera.position = board.position
	
	# Wait for board to be ready
	await get_tree().process_frame
	
	# Initialize systems
	_setup_dice()
	_spawn_player_tokens()

func _setup_dice() -> void:
	"""Setup dice for players - extensible for per-player dice later"""
	# Get character selections from Gamestate
	if Gamestate.has_meta("character_selections"):
		var selections = Gamestate.get_meta("character_selections")
		player_characters = selections.duplicate()
		
		# Create a die for each player
		for player_id in selections:
			var die = Dice.new(6, player_id)
			player_dice[player_id] = die
		
		# Set current player's die in the roller
		if current_player_id in player_dice:
			dice_roller.set_dice(player_dice[current_player_id])
	else:
		# Fallback: create default die
		var die = Dice.new(6, 1)
		player_dice[1] = die
		player_characters[1] = "Warrior"
		dice_roller.set_dice(die)
	
	# Connect dice roll completion
	if dice_roller:
		dice_roller.roll_completed.connect(_on_dice_rolled)

func _spawn_player_tokens() -> void:
	"""Create tokens for all players and place them on the starting tile"""
	if not board:
		push_error("Board not found!")
		return
	
	# Get starting tile (first tile in board)
	var start_tile_index = 0
	var start_tile = board.get_child(start_tile_index) if board.get_child_count() > 0 else null
	
	if not start_tile:
		push_error("No tiles found on board!")
		return
	
	var start_position = start_tile.position
	
	# Create a token for each player
	var player_index = 0
	for player_id in player_characters:
		var character_name = player_characters[player_id]
		var color = PLAYER_COLORS[player_index % PLAYER_COLORS.size()]
		
		# Determine player name
		var player_name = "You" if player_id == 1 else "Bot %d" % (player_id - 1)
		
		# Instantiate token
		var token = TOKEN_SCENE.instantiate()
		tokens_container.add_child(token)
		
		# Setup token with player name and character
		token.setup(player_id, character_name, player_name, color, start_tile_index)
		
		# Position token on starting tile (offset if multiple players)
		# Spread tokens in a circle around the tile for better visibility
		var angle = (2 * PI * player_index) / max(player_characters.size(), 1)
		var offset_distance = 25.0  # Distance from tile center
		var offset = Vector2(cos(angle), sin(angle)) * offset_distance
		token.position = start_position + offset
		
		# Mark first player as current
		if player_id == current_player_id:
			token.set_current_player(true)
		
		# Store reference
		player_tokens[player_id] = token
		
		# Connect signal
		token.token_clicked.connect(_on_token_clicked)
		
		player_index += 1
	
	print("Spawned %d player tokens" % player_tokens.size())

func _on_token_clicked(token: PlayerToken) -> void:
	"""Handle token click"""
	print("Clicked token: Player %d (%s)" % [token.player_id, token.character_name])

func _on_dice_rolled(result: int) -> void:
	"""Handle dice roll result"""
	print("Player %d rolled: %d" % [current_player_id, result])
	
	# TODO: Implement movement based on roll
	# For now just show the result
	
	# Get current player's dice stats (for future luck display)
	if current_player_id in player_dice:
		var stats = player_dice[current_player_id].get_stats()
		print("Dice stats: ", stats)

func _on_back_pressed() -> void:
	# Return to main menu
	SceneManager.go_to_main_menu()

## Switch to another player's die (for turn-based play later)
func switch_player_dice(player_id: int) -> void:
	if player_id in player_dice:
		current_player_id = player_id
		dice_roller.set_dice(player_dice[player_id])
