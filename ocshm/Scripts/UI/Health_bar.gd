class_name HealthBar
extends Node2D


@export var health_component: HealthComponent


@onready var hearts: Array[HeartIcon] = [
	$Heart1,
	$Heart2,
	$Heart3
]


func _ready() -> void:
	if health_component == null:
		push_error(
			"HealthBar has no HealthComponent."
		)
		return

	health_component.health_changed.connect(
		_on_health_changed
	)

	_update_hearts(
		health_component.current_health,
		false
	)


func _on_health_changed(
	new_health: int
) -> void:

	_update_hearts(
		new_health,
		true
	)


func _update_hearts(
	health: int,
	animate: bool
) -> void:

	for i in range(hearts.size()):

		#
		# Each heart represents 2 HP.
		#
		var heart_health: int = clampi(health - (i * 2),0,2)
		hearts[i].set_health_units(heart_health,animate)
