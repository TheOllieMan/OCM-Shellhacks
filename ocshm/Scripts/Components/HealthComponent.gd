class_name HealthComponent
extends Node


signal died
signal health_changed(new_amount: int)


@export var max_health: int = 4

var current_health: int


func _ready() -> void:
	current_health = max_health

	health_changed.emit(
		current_health
	)


func damage(amount: int) -> void:
	if amount <= 0:
		return

	if current_health <= 0:
		return

	current_health = clampi(
		current_health - amount,
		0,
		max_health
	)

	health_changed.emit(
		current_health
	)

	print("Took ", amount, " damage!")
	print("Health remaining: ", current_health)

	if current_health == 0:
		died.emit()


func heal(amount: int) -> void:
	if amount <= 0:
		return

	current_health = clampi(
		current_health + amount,
		0,
		max_health
	)

	health_changed.emit(
		current_health
	)
