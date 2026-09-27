extends CharacterBody2D

@export var speed = 200

@onready var animated_sprite = $AnimatedSprite2D
#@onready var key_icon = $HUD/KeyIcon
@onready var health_component: HealthComponent = ($HealthComponent)
#@onready var _animation_player = $AnimationPlayer
@export_file("*.tscn")
var main_menu_scene: String

@onready var camera: Camera2D = $Camera2D
@onready var attack_hitbox: AttackHitbox = ($AttackHitbox)

var is_attacking: bool = false
var facing_direction: Vector2 = Vector2.DOWN

#var has_key := false:
	#set(value):
		#has_key = value
		#if key_icon:
			#key_icon.visible = value

func _ready() -> void:
	camera.enabled = true
	camera.make_current()
	health_component.died.connect(_on_died)
	#key_icon.visible = false

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO

	_handle_movement()

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed
		move_and_slide()

	# Do NOT stop the sprite while an attack animation is playing.
	elif not is_attacking:
		animated_sprite.stop()

#Movement Animations
func _handle_movement() -> void:

	if Input.is_action_pressed("Up"):
		velocity.y -= 1
		facing_direction = Vector2.UP

		if not is_attacking:
			animated_sprite.play("Walk_Up")


	elif Input.is_action_pressed("Left"):
		velocity.x -= 1
		facing_direction = Vector2.LEFT

		if not is_attacking:
			animated_sprite.play("Walk_Left")


	elif Input.is_action_pressed("Right"):
		velocity.x += 1
		facing_direction = Vector2.RIGHT

		if not is_attacking:
			animated_sprite.play("Walk_Right")


	elif Input.is_action_pressed("Down"):
		velocity.y += 1
		facing_direction = Vector2.DOWN

		if not is_attacking:
			animated_sprite.play("Walk_Down")

# Move and handle collisions
func _on_died() -> void:
	print("Cal died.")

	# Stop the player from continuing to move/interact.
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)

	# Load the main menu through our loading-screen system.
	SceneLoader.load_scene(
		main_menu_scene
	)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		_attack()


func _attack() -> void:
	if is_attacking:
		return

	is_attacking = true

	#_position_attack_hitbox()

	match facing_direction:

		Vector2.UP:
			animated_sprite.play("Attack_Up")

		Vector2.DOWN:
			animated_sprite.play("Attack_Down")

		Vector2.LEFT:
			animated_sprite.play("Attack_Left")

		Vector2.RIGHT:
			animated_sprite.play("Attack_Right")


	attack_hitbox.begin_attack()

	await animated_sprite.animation_finished

	attack_hitbox.end_attack()

	is_attacking = false
	

func _position_attack_hitbox() -> void:

	var attack_distance: float = 24.0

	attack_hitbox.position = (
		facing_direction
		* attack_distance
	)
