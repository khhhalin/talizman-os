extends Node
class_name CardManager

var deck_data: Dictionary = {}
var adventure_deck: Array = [] # Array<StandardCard>
var spell_deck: Array = [] # Array<StandardCard>
var purchase_deck: Array = [] # Array<StandardCard>

func load_decks() -> void:
	# TODO: load deck_data and populate decks
	pass

func draw_adventure_card() -> StandardCard:
	return adventure_deck.pop_back() if adventure_deck.size() > 0 else null

func draw_spell_card() -> StandardCard:
	return spell_deck.pop_back() if spell_deck.size() > 0 else null

func shuffle_deck(deck_type: String) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var deck := adventure_deck if deck_type == "ADVENTURE" else (spell_deck if deck_type == "SPELL" else purchase_deck)
	deck.shuffle()