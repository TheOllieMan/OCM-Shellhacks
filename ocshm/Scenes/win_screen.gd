extends Control

@export_file("*.tscn") var main_menu_scene: String


func _ready() -> void:
	var button := _find_button(self)

	if button == null:
		push_error("WinScreen: no Button found. Is it a Button node inside this scene?")
		return

	button.pressed.connect(_on_main_menu_pressed)


func _find_button(node: Node) -> Button:
	for child in node.get_children():
		if child is Button:
			return child
		var found := _find_button(child)
		if found:
			return found
	return null


func _on_main_menu_pressed() -> void:
	GameState.reset_run()
	get_tree().change_scene_to_file(main_menu_scene)
