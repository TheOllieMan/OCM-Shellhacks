class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent 

func take_hit(attack:float):
	if health_component:
		health_component.damage(attack)
