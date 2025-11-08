extends Control

# This script handles the options menu functionality
@onready var keybinds_button = $Panel/VBoxContainer/Keybinds
@onready var audio_button = $Panel/VBoxContainer/Options
@onready var exit_button = $Panel/VBoxContainer/Exit

func _ready() -> void:
	keybinds_button.connect("pressed", Callable(self, "_on_keybinds_pressed"))
	audio_button.connect("pressed", Callable(self, "_on_audio_pressed"))
	exit_button.connect("pressed", Callable(self, "_on_exit_pressed"))

func _on_keybinds_pressed() -> void:
	# Navigate to the keybinds menu
	SceneManager.go_to_input_remap()

func _on_audio_pressed() -> void:
	# Placeholder for audio settings functionality
	print("Audio settings pressed")

func _on_exit_pressed() -> void:
	# Return to the main menu
	SceneManager.go_to_main_menu()
