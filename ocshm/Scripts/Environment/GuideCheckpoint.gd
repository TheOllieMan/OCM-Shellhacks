class_name GuideCheckpoint
extends Area2D

signal reached(checkpoint: GuideCheckpoint)

@export var checkpoint_id: StringName
# Checkpoints this checkpoint is allowed to connect to.
@export var neighbors: Array[GuideCheckpoint] = []

func _ready() -> void:
	if checkpoint_id.is_empty():
		var node_name: String = name

		if node_name.begins_with("Checkpoint_"):
			checkpoint_id = StringName(
				node_name.trim_prefix("Checkpoint_")
			)
		else:
			checkpoint_id = StringName(node_name)

	body_entered.connect(_on_body_entered)

	print("Checkpoint ready: ", checkpoint_id)


func _on_body_entered(body: Node2D) -> void:
	print(
		"Something entered checkpoint ",
		checkpoint_id,
		": ",
		body.name
	)
	
	if body.is_in_group("player"):
		print("PLAYER reached checkpoint: ", checkpoint_id)
		reached.emit(self)
	else: 
		print("Body was NOT in player group.")
