extends Node
class_name NetworkManager

func setup_server() -> void:
	# TODO: initialize server networking
	pass

func setup_client() -> void:
	# TODO: initialize client networking
	pass

func sync_game_state() -> void:
	# TODO: push or request authoritative state
	pass

func handle_player_action(action: Dictionary) -> void:
	# TODO: validate and route player actions
	pass

@rpc("any_peer", "call_local")
func sync_player_position(player_id: int, position: Vector2) -> void:
	# TODO: apply position snapshot for player
	pass

@rpc("any_peer", "call_local")
func sync_card_draw(player_id: int, card_data: Dictionary) -> void:
	# TODO: apply card draw event
	pass

@rpc("any_peer", "call_local")
func sync_combat_result(result) -> void:
	# result expected to be a CombatResult compatible Dictionary or Resource
	# TODO: apply combat results
	pass