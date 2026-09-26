extends CharacterBody2D

@export var speed = 400

@onready var animated_sprite = $AnimatedSprite2D
#@onready var _animation_player = $AnimationPlayer


func _physics_process(delta):
	
	velocity = Vector2.ZERO

	Animate()


	if velocity == Vector2.ZERO:
		animated_sprite.stop()
		return


	# Set velocity based on direction and speed
	velocity = velocity.normalized() * speed
	

	move_and_slide()

#Movement Animations
func Animate():

#Up
	if Input.is_action_pressed("Up"):
		velocity.y -= 1
		animated_sprite.play("Walk_Up")

#Left
	elif Input.is_action_pressed("Left"):
		velocity.x -= 1
		animated_sprite.play("Walk_Left")
		$AnimatedSprite2D.flip_h = velocity.x < 0

#Right
	elif Input.is_action_pressed("Right"):
		velocity.x += 1
		animated_sprite.play("Walk_Right")
		$AnimatedSprite2D.flip_h = false

#Down
	elif Input.is_action_pressed("Down"):
		velocity.y += 1
		animated_sprite.play("Walk_Down")

# Move and handle collisions
