class_name GuideCheckpoint
extends Area2D

signal reached(checkpoint: GuideCheckpoint)

@export var checkpoint_id: StringName
# Checkpoints this checkpoint is allowed to connect to.
@export var neighbors: Array[GuideCheckpoint] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		reached.emit(self)
