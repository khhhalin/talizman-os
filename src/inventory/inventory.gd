extends Node
class_name Inventory

@export var capacity: int = 0
var contents: Array = [] # Array<StandardCard>

func add_card(card) -> bool:
	# ...validate capacity, type, etc...
	if is_full():
		return false
	contents.append(card)
	return true

func remove_card(card) -> void:
	contents.erase(card)

func has_card(name: String) -> bool:
	for c in contents:
		if c is Resource and "name" in c and c.name == name:
			return true
	return false

func filter_by_type(type_name: String) -> Array:
	var out: Array = []
	for c in contents:
		if c is Resource and "type" in c and str(c.type) == type_name:
			out.append(c)
	return out

func is_full() -> bool:
	return capacity > 0 and contents.size() >= capacity