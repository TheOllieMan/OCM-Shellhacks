class_name HurtboxComponent
extends Area2D


@export var health_component: HealthComponent

@export var use_invulnerability: bool = false

@export_range(0.0, 3.0, 0.05)
var invulnerability_time: float = 0.5


var invulnerable: bool = false


func take_hit(attack: int) -> void:
	if health_component == null:
		return

	if invulnerable:
		return

	health_component.damage(attack)

	if use_invulnerability:
		_start_invulnerability()


func _start_invulnerability() -> void:
	invulnerable = true

	await get_tree().create_timer(
		invulnerability_time
	).timeout

	invulnerable = false
