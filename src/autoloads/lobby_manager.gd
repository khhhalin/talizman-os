extends Node
class_name LobbyManager

signal lobby_opened
signal lobby_closed
signal player_joined(name)
signal player_left(name)

func open_lobby() -> void:
	lobby_opened.emit()

func close_lobby() -> void:
	lobby_closed.emit()

func host(name: String) -> void:
	if Engine.has_singleton("gamestate"):
		gamestate.host_game(name)

func join(ip: String, name: String) -> void:
	if Engine.has_singleton("gamestate"):
		gamestate.join_game(ip, name)

func start_game() -> void:
	if Engine.has_singleton("gamestate") and multiplayer.is_server():
		gamestate.begin_game()