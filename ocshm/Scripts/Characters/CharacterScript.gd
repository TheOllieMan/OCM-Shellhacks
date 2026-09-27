extends CharacterBody2D


const SPEED = 160.0


var player: Node2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_component: HealthComponent = $HealthComponent


func _ready() -> void:
	player = (
		get_tree().get_first_node_in_group("player")
		as Node2D
	)

	if player == null:
		push_warning(
			"Robot could not find player."
		)

	health_component.died.connect(
		_on_died
	)


func _physics_process(_delta: float) -> void:
	if player == null:
		return

	nav_agent.target_position = (
		player.global_position
	)

	var next: Vector2 = (
		nav_agent.get_next_path_position()
	)

	velocity = (
		global_position.direction_to(next)
		* SPEED
	)

	move_and_slide()


func _on_died() -> void:
	print("RobotDied")
	queue_free()
