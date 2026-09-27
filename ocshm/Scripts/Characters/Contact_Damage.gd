class_name ContactDamageComponent
extends Area2D


@export var damage: int = 1

var already_hit: Array[HurtboxComponent] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as HurtboxComponent

	if hurtbox == null:
		return

	if hurtbox in already_hit:
		return

	already_hit.append(hurtbox)

	hurtbox.take_hit(damage)


func _on_area_exited(area: Area2D) -> void:
	var hurtbox := area as HurtboxComponent

	if hurtbox == null:
		return

	already_hit.erase(hurtbox)
