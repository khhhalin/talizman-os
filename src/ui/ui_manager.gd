extends CanvasLayer
class_name UIManager

func show_player_stats(player: Node) -> void:
	# ...display player stats in PlayerStatsUI...
	pass

func show_turn_indicator(player: Node) -> void:
	# ...display current player's turn in TurnIndicatorUI...
	pass

func show_inventory(target: Node) -> void:
	# ...display inventory for any IHasInventory or Inventory node...
	pass

func show_combat_interface(attacker: Node, defender: Node) -> void:
	# ...open CombatUI with given participants...
	pass

func show_dice_roll(result: int) -> void:
	# ...show DiceUI with last roll...
	pass