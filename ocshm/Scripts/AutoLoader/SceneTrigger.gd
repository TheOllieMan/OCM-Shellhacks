extends Area2D

@export_file("*.tscn") var next_scene: String
@export var keys_needed: int = 3

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	if GameState.key_count() >= keys_needed:
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
	else:
		print("Need ", keys_needed, " keys. You have ", GameState.key_count())
