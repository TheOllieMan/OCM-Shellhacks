extends Node2D

const KEY_SCENE = preload("res://Scenes/KeyScene.tscn")

func spawn_key(pos: Vector2):
	var key = KEY_SCENE.instantiate()
	key.global_position = pos
	get_tree().current_scene.add_child(key)
