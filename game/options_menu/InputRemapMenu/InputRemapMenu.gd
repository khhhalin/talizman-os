extends Control

## InputRemapMenu - Handles keybind customization

@onready var back_button = $BackButton

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	# Return to options menu
	SceneManager.go_to_options()
