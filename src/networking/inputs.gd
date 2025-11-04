extends Node
class_name Inputs

@export var motion := Vector2.ZERO:
	set(value):
		motion = value.clamp(Vector2(-1, -1), Vector2(1, 1))

@export var bombing := false

func update() -> void:
	var m := Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		m.x -= 1
	if Input.is_action_pressed("move_right"):
		m.x += 1
	if Input.is_action_pressed("move_up"):
		m.y -= 1
	if Input.is_action_pressed("move_down"):
		m.y += 1
	motion = m
	bombing = Input.is_action_pressed("set_bomb")