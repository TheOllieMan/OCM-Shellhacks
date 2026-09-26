class_name HealthComponent
extends Node

signal died
signal health_changed(new_amount)

@export var max_health := 4
var current_health: float

func _ready():
	current_health = max_health

func damage(attack:float):
	current_health -=attack
	health_changed.emit(current_health)
	
	print("Took ", attack, " damage!")
	print("Health remaining: ", current_health)
	
	if current_health <= 0:
		died.emit()
