extends Node
class_name TurnManager

signal turn_started(player)
signal turn_ended(player)
signal round_completed()

var player_order: Array = [] # Array<Player>
var current_turn_index: int = -1
var game_active: bool = false

func start_turn() -> void:
	# ...start logic, emit signal...
	if player_order.is_empty():
		return
	game_active = true
	current_turn_index = clamp(current_turn_index, 0, player_order.size() - 1)
	turn_started.emit(player_order[current_turn_index])

func end_turn() -> void:
	if player_order.is_empty():
		return
	turn_ended.emit(player_order[current_turn_index])
	next_player()

func next_player() -> void:
	if player_order.is_empty():
		return
	current_turn_index = (current_turn_index + 1) % player_order.size()
	if current_turn_index == 0:
		round_completed.emit()
	start_turn()

func get_current_player():
	if player_order.is_empty() or current_turn_index < 0:
		return null
	return player_order[current_turn_index]

func is_player_turn(player_id: int) -> bool:
	var p = get_current_player()
	return p != null and ("player_id" in p and p.player_id == player_id)