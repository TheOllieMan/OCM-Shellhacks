#class_name KeyPickup
extends Area2D


@export var key_id: StringName


func _ready() -> void:
	body_entered.connect(
		_on_body_entered
	)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	GameState.collect_key(
		key_id
	)

	print(
		"Key obtained: ",
		key_id
	)

	queue_free()
