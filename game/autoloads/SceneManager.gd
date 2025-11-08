
extends Node

"""
SceneManager (autoload)

Centralized scene navigation helpers.
Use named keys from SCENES or pass a raw path to change_scene().
"""

# Named scene paths - change these to point to your scenes
const SCENES := {
	"MainMenu": "res://game/main_menu/main_menu.tscn",
	"OptionsMenu": "res://game/options_menu/options_menu.tscn",
	"LobbyManager": "res://game/lobby_manager/lobby_manager.tscn",
	"InputRemapMenu": "res://game/options_menu/InputRemapMenu/InputRemapMenu.tscn",
}

# Cache for loaded PackedScene resources so we don't reload them repeatedly
var _packed_cache: Dictionary = {}

# Signals emitted around scene changes
signal scene_changing(scene_key: String, path: String)
signal scene_changed(scene_key: String, path: String)

func _ready() -> void:
	# No special initialization required; keep as an autoload singleton
	pass


func _resolve_path(name_or_path: String) -> String:
	# If caller passed a named key, return the mapped path, otherwise treat as a path.
	if SCENES.has(name_or_path):
		return SCENES[name_or_path]
	return name_or_path


func _load_packed_scene(path: String) -> PackedScene:
	if _packed_cache.has(path):
		return _packed_cache[path]
	var res = ResourceLoader.load(path)
	if res == null or not res is PackedScene:
		return null
	_packed_cache[path] = res
	return res


func change_scene(name_or_path: String) -> int:
	"""
	Change scene by named key (from SCENES) or by direct path.
	Loads and caches PackedScenes, calls get_tree().change_scene_to_packed(),
	then awaits the SceneTree.scene_changed signal before returning OK.
	Returns an Error constant (OK on success).
	"""
	var path = _resolve_path(name_or_path)
	if path == "":
		push_error("SceneManager.change_scene: empty scene key/path")
		return ERR_INVALID_PARAMETER

	var packed = _load_packed_scene(path)
	if packed == null:
		push_error("SceneManager.change_scene: failed to load PackedScene: %s" % path)
		return ERR_CANT_OPEN

	emit_signal("scene_changing", name_or_path, path)

	var err = get_tree().change_scene_to_packed(packed)
	if err != OK:
		push_error("SceneManager.change_scene: change_scene_to_packed failed for %s (err=%d)" % [path, err])
		return err

	# Wait until the new scene is fully added/initialized.
	await get_tree().scene_changed

	emit_signal("scene_changed", name_or_path, path)
	return OK


func go_to_main_menu() -> int:
	return await change_scene("MainMenu")


func go_to_options() -> int:
	return await change_scene("OptionsMenu")


func go_to_lobby() -> int:
	return await change_scene("LobbyManager")


func go_to_input_remap() -> int:
	return await change_scene("InputRemapMenu")


func reload_current_scene() -> int:
	return get_tree().reload_current_scene()


func quit_game() -> void:
	get_tree().quit()
