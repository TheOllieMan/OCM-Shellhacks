class_name AttackHitbox
extends Area2D


@export var damage: int = 1


var already_hit: Array[HurtboxComponent] = []


func _ready() -> void:
	monitoring = false

	area_entered.connect(
		_on_area_entered
	)


func begin_attack() -> void:
	print("ATTACK HITBOX ON")

	already_hit.clear()
	monitoring = true


func end_attack() -> void:
	print("ATTACK HITBOX OFF")

	monitoring = false
	already_hit.clear()


func _on_area_entered(area: Area2D) -> void:
	print(
		"Attack touched area: ",
		area.name
	)

	var hurtbox := area as HurtboxComponent

	if hurtbox == null:
		print("Not a HurtboxComponent")
		return

	if hurtbox in already_hit:
		print("Already hit this enemy")
		return

	already_hit.append(
		hurtbox
	)

	print("ENEMY HIT FOR ", damage)

	hurtbox.take_hit(
		damage
	)
