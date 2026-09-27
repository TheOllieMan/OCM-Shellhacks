class_name SceneSpawnPoint
extends Marker2D


@export var spawn_id: StringName


func _ready() -> void:
	add_to_group("scene_spawn_points")
