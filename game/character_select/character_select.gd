extends Control

## Character Selection Lobby
## Players select characters before game starts
## Simple implementation - fancy drafts come later

# Character data - simple for now
const CHARACTERS = [
	{"name": "Warrior", "strength": 5, "craft": 2, "life": 5, "fate": 2},
	{"name": "Wizard", "strength": 2, "craft": 5, "life": 4, "fate": 3},
	{"name": "Assassin", "strength": 4, "craft": 3, "life": 4, "fate": 3},
	{"name": "Priest", "strength": 3, "craft": 4, "life": 4, "fate": 3},
	{"name": "Elf", "strength": 3, "craft": 3, "life": 4, "fate": 4},
	{"name": "Dwarf", "strength": 4, "craft": 2, "life": 5, "fate": 2}
]

var is_single_player: bool = false
var player_selections: Dictionary = {}  # player_id -> character_name
var bot_count: int = 0

@onready var character_list = $Panel/VBox/HBox/LeftPanel/CharacterList
@onready var player_status = $Panel/VBox/HBox/RightPanel/PlayerStatus
@onready var start_button = $Panel/VBox/ButtonBox/StartButton
@onready var back_button = $Panel/VBox/ButtonBox/BackButton

func _ready() -> void:
	# Connect buttons
	start_button.pressed.connect(_on_start_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	# Populate character list
	_populate_character_list()
	
	# Update UI
	_update_ui()

func setup_single_player(num_bots: int = 1) -> void:
	"""Setup for single player with bots"""
	is_single_player = true
	bot_count = num_bots
	_update_ui()

func setup_multiplayer() -> void:
	"""Setup for multiplayer"""
	is_single_player = false
	bot_count = 0
	_update_ui()

func _populate_character_list() -> void:
	"""Fill the character list with buttons"""
	character_list.clear()
	
	for i in range(CHARACTERS.size()):
		var char_data = CHARACTERS[i]
		var text = "%s (STR:%d CRA:%d LIFE:%d FATE:%d)" % [
			char_data.name,
			char_data.strength,
			char_data.craft,
			char_data.life,
			char_data.fate
		]
		character_list.add_item(text)

func _on_character_list_activated(index: int) -> void:
	"""Player selected a character"""
	var char_name = CHARACTERS[index].name
	var player_id = 1  # For now, single player only uses ID 1
	
	# Check if character already taken
	if char_name in player_selections.values():
		push_warning("Character already selected!")
		return
	
	# Set selection
	player_selections[player_id] = char_name
	
	# Auto-select for bots if single player
	if is_single_player:
		_select_bot_characters()
	
	_update_ui()

func _select_bot_characters() -> void:
	"""Auto-select characters for bots"""
	var available = _get_available_characters()
	
	for bot_id in range(2, 2 + bot_count):
		if bot_id in player_selections:
			continue
		
		if available.size() > 0:
			var random_char = available.pick_random()
			player_selections[bot_id] = random_char
			available.erase(random_char)

func _get_available_characters() -> Array:
	"""Get list of characters not yet selected"""
	var available: Array = []
	for char_data in CHARACTERS:
		if not char_data.name in player_selections.values():
			available.append(char_data.name)
	return available

func _update_ui() -> void:
	"""Update the player status display"""
	var status_text = ""
	
	if is_single_player:
		# Show player + bots
		if 1 in player_selections:
			status_text += "You: %s\n" % player_selections[1]
		else:
			status_text += "You: [Select Character]\n"
		
		for bot_id in range(2, 2 + bot_count):
			if bot_id in player_selections:
				status_text += "Bot %d: %s\n" % [bot_id - 1, player_selections[bot_id]]
			else:
				status_text += "Bot %d: Waiting...\n" % [bot_id - 1]
	else:
		# Multiplayer - show all players
		for player_id in player_selections:
			status_text += "Player %d: %s\n" % [player_id, player_selections[player_id]]
	
	player_status.text = status_text
	
	# Enable start button only if all have selected
	var all_selected = _check_all_selected()
	start_button.disabled = not all_selected

func _check_all_selected() -> bool:
	"""Check if all players/bots have selected characters"""
	if is_single_player:
		var required = 1 + bot_count
		return player_selections.size() == required
	else:
		# For multiplayer, need at least 1 player
		return player_selections.size() >= 1

func _on_start_pressed() -> void:
	"""Start the game with selected characters"""
	if not _check_all_selected():
		return
	
	# Store selections in Gamestate for use in gameplay
	Gamestate.set_meta("character_selections", player_selections)
	Gamestate.set_meta("characters_data", CHARACTERS)
	
	# Go to gameplay
	SceneManager.go_to_gameplay()

func _on_back_pressed() -> void:
	"""Return to lobby"""
	player_selections.clear()
	SceneManager.go_to_lobby()

func _on_character_list_item_selected(index: int) -> void:
	"""Handle character selection from list"""
	_on_character_list_activated(index)
