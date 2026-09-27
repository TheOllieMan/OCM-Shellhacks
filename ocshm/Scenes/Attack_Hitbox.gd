class_name AttackHitbox
extends Area2D


@export var damage: int = 1


var attack_active: bool = false
var already_hit: Array[HurtboxComponent] = []


func _ready() -> void:
	monitoring = true

	area_entered.connect(
		_on_area_entered
	)


func begin_attack() -> void:
	print("ATTACK HITBOX ON")

	attack_active = true
	already_hit.clear()

	# Important:
	# damage enemies that are already overlapping
	# when the swing starts.
	for area in get_overlapping_areas():
		_try_hit(area)


func end_attack() -> void:
	print("ATTACK HITBOX OFF")

	attack_active = false
	already_hit.clear()


func _on_area_entered(area: Area2D) -> void:
	if not attack_active:
		return

	_try_hit(area)


func _try_hit(area: Area2D) -> void:
	var hurtbox := area as HurtboxComponent

	if hurtbox == null:
		return

	if hurtbox in already_hit:
		return

	already_hit.append(hurtbox)

	print(
		"ENEMY HIT FOR ",
		damage
	)

	hurtbox.take_hit(
		damage
	)
