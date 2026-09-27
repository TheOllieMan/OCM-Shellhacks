extends Area2D

@export_file("*.tscn") var next_scene: String

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file.call_deferred(next_scene)
