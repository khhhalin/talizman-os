extends EditorPlugin

var inspector_plugin: EditorInspectorPlugin

func _enter_tree():
    inspector_plugin = BoardInspectorPlugin.new(self)
    add_inspector_plugin(inspector_plugin)

func _exit_tree():
    if inspector_plugin:
        remove_inspector_plugin(inspector_plugin)


class BoardInspectorPlugin:
    extends EditorInspectorPlugin

    var editor: EditorPlugin

    func _init(_editor: EditorPlugin):
        editor = _editor

    func can_handle(obj) -> bool:
        # handle Node2D that has a rebuild_grid or build_from_map method
        return obj is Node and (obj.has_method("build_from_map") or obj.has_method("rebuild_grid"))

    func parse_begin(object):
        var btn = Button.new()
        btn.text = "Rebuild from Map"
        btn.pressed = false
        btn.connect("pressed", Callable(self, "_on_rebuild_pressed"), [object])
        add_custom_control(btn)

        var viz = CheckBox.new()
        viz.text = "Visualize Edges"
        viz.pressed = bool(object.get("_editor_visualize_edges")) if object.has_method("get") else false
        viz.connect("toggled", Callable(self, "_on_viz_toggled"), [object])
        add_custom_control(viz)

    func _on_rebuild_pressed(object):
        if object and object.has_method("build_from_map"):
            object.build_from_map()
        elif object and object.has_method("rebuild_grid"):
            object.rebuild_grid()

    func _on_viz_toggled(pressed: bool, object):
        # store a simple flag on the object so its script can draw edges in _draw if desired
        if object:
            if object.has_method("set"):
                object.set("_editor_visualize_edges", pressed)
            else:
                object._editor_visualize_edges = pressed
