extends Control

# This script handles the main menu functionality
@onready var play_button = $Panel/VBoxContainer/Play
@onready var options_button = $Panel/VBoxContainer/Options
@onready var exit_button = $Panel/VBoxContainer/Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.connect("pressed", Callable(self, "_on_play_pressed"))
	options_button.connect("pressed", Callable(self, "_on_options_pressed"))
	exit_button.connect("pressed", Callable(self, "_on_exit_pressed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Updated to use SceneManager for scene transitions
func _on_play_pressed():
	SceneManager.go_to_lobby()

func _on_options_pressed():
	SceneManager.go_to_options()

func _on_exit_pressed():
	SceneManager.quit_game()
