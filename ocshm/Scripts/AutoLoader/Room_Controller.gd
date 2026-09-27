class_name RoomController
extends Node


@export var key_scene: PackedScene

@export var key_spawn: Marker2D

@export var key_id: StringName

@export var music_player: AudioStreamPlayer

@export var enemy_group: StringName = &"room_enemies"


var enemies_remaining: int = 0

var key_spawned: bool = false


func _ready() -> void:
	_start_music()

	_register_enemies()


func _start_music() -> void:
	if music_player == null:
		return

	music_player.play()


func _register_enemies() -> void:
	var enemies: Array[Node] = (
		get_tree().get_nodes_in_group(
			enemy_group
		)
	)

	enemies_remaining = enemies.size()

	print(
		"Enemies remaining: ",
		enemies_remaining
	)


	for enemy in enemies:

		var health := (
			enemy.get_node_or_null(
				"HealthComponent"
			)
			as HealthComponent
		)

		if health == null:
			push_warning(
				str(enemy.name)
				+ " has no HealthComponent."
			)
			continue

		health.died.connect(
			_on_enemy_died,
			CONNECT_ONE_SHOT
		)


	if enemies_remaining == 0:
		_on_all_enemies_defeated()


func _on_enemy_died() -> void:
	enemies_remaining -= 1

	print(
		"Enemies remaining: ",
		enemies_remaining
	)

	if enemies_remaining <= 0:
		_on_all_enemies_defeated()


func _on_all_enemies_defeated() -> void:
	print("ROOM CLEARED")

	_spawn_key()


func _spawn_key() -> void:
	if key_spawned:
		return

	# Don't spawn a key Cal already owns.
	if GameState.has_key(key_id):
		return

	if key_scene == null:
		push_error(
			"RoomController has no Key Scene."
		)
		return

	if key_spawn == null:
		push_error(
			"RoomController has no KeySpawn."
		)
		return


	var key := (
		key_scene.instantiate()
		as KeyPickup
	)

	if key == null:
		push_error(
			"Key scene root must use KeyPickup.gd."
		)
		return


	key.key_id = key_id

	get_tree().current_scene.add_child(
		key
	)

	key.global_position = (
		key_spawn.global_position
	)

	key_spawned = true

	print(
		"Spawned key: ",
		key_id
	)
