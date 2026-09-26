class_name LightingSystem
extends Node2D


@export var guide_renderer: GuidePathRenderer


func show_guide_path(world_path: PackedVector2Array) -> void:
	if guide_renderer == null:
		push_error("LightingSystem has no GuidePathRenderer assigned.")
		return

	guide_renderer.set_global_path(world_path)


func clear_guide_path() -> void:
	if guide_renderer == null:
		return

	guide_renderer.set_path(PackedVector2Array())
