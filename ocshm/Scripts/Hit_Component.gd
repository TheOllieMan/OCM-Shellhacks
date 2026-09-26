class_name HitboxComponent
extends  Area2D

@export var attack_damage := 1.0

#func _init():
func _ready():
	area_entered.connect(_on_area_entered)


func _on_area_entered(area):
	if area is HurtboxComponent:
		area.take_hit(attack_damage)
