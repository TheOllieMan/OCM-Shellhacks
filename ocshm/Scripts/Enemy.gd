extends Area2D

@export var max_health := 4
# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthComponent.died.connect(on_died)

func on_died() -> void: queue_free()
