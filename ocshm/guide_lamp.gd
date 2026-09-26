class_name GuideLamp
extends Node2D


@onready var point_light: PointLight2D = $PointLight2D
@onready var pool_glow: MeshInstance2D = $PoolGlow


@export_range(0.0, 2.0, 0.05)
var base_energy: float = 0.30

@export_range(0.0, 1.0, 0.05)
var base_glow_alpha: float = 0.18


var path_progress: float = 0.0


func configure(
	world_position: Vector2,
	progress: float
) -> void:

	global_position = world_position
	path_progress = progress

	visible = true

	set_intensity(1.0)


func set_intensity(multiplier: float) -> void:
	if point_light != null:
		point_light.energy = (
			base_energy * multiplier
		)

	if pool_glow != null:
		var glow_color: Color = pool_glow.modulate

		glow_color.a = clampf(
			base_glow_alpha * multiplier,
			0.0,
			1.0
		)

		pool_glow.modulate = glow_color


func deactivate() -> void:
	visible = false
