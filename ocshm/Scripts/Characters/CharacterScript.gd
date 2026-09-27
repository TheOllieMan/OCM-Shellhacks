extends CharacterBody2D


const SPEED = 160.0

@export var hidden_key: KeyPickup

var player: Node2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_component: HealthComponent = $HealthComponent


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		push_warning("Robot could not find player.")

	health_component.died.connect(_on_died)

	# hide the key until the robot dies
	if hidden_key:
		hidden_key.visible = false
		hidden_key.set_deferred("monitoring", false)

	# wait one physics frame so the navigation map is ready
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)


func _physics_process(_delta: float) -> void:
	if player == null:
		return

	nav_agent.target_position = player.global_position

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next: Vector2 = nav_agent.get_next_path_position()
	velocity = global_position.direction_to(next) * SPEED
	move_and_slide()


func _on_died() -> void:
	print("RobotDied")

	if hidden_key:
		hidden_key.global_position = global_position
		hidden_key.visible = true
		hidden_key.set_deferred("monitoring", true)

		hidden_key.scale = Vector2.ZERO
		var tween = hidden_key.create_tween()
		tween.tween_property(hidden_key, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK)

	queue_free()
