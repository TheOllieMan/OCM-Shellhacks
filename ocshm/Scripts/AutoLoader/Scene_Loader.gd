extends Node


signal progress_changed(progress)
signal load_finished


var loading_screen: PackedScene = preload(
	"uid://dnd3dx3vl40hc"
)

var loaded_resource: PackedScene
var scene_path: String

var progress: Array = []

var use_sub_threads: bool = true

var target_spawn_id: StringName = &""


func _ready() -> void:
	set_process(false)


func load_scene(
	_scene_path: String,
	_spawn_id: StringName = &""
) -> void:

	scene_path = _scene_path
	target_spawn_id = _spawn_id

	var new_load_screen = (
		loading_screen.instantiate()
	)

	add_child(new_load_screen)

	# Progress needs to receive MANY updates,
	# so do NOT make this one-shot.
	progress_changed.connect(
		new_load_screen._on_progress_changed
	)

	# This should happen only once per loading screen.
	load_finished.connect(
		new_load_screen._on_load_finished,
		CONNECT_ONE_SHOT
	)

	# Don't begin loading until the screen
	# has completely faded to black.
	new_load_screen.loading_screen_ready.connect(
		start_load,
		CONNECT_ONE_SHOT
	)

func start_load() -> void:
	var state = (
		ResourceLoader.load_threaded_request(
			scene_path,
			"",
			use_sub_threads
		)
	)

	if state == OK:
		set_process(true)
	else:
		push_error(
			"Failed to begin loading scene: "
			+ scene_path
		)


func _process(_delta: float) -> void:

	var load_status = (
		ResourceLoader.load_threaded_get_status(
			scene_path,
			progress
		)
	)

	if not progress.is_empty():
		progress_changed.emit(
			progress[0]
		)

	match load_status:

		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, \
		ResourceLoader.THREAD_LOAD_FAILED:

			set_process(false)

			push_error(
				"Failed to load scene: "
				+ scene_path
			)


		ResourceLoader.THREAD_LOAD_LOADED:

			set_process(false)

			loaded_resource = (
				ResourceLoader.load_threaded_get(
					scene_path
				)
			)

			get_tree().change_scene_to_packed(
				loaded_resource
			)

			# Wait until Level 2 actually exists
			# in the SceneTree.
			await get_tree().scene_changed

			# Now find Cal and move him.
			await _place_player_at_spawn()

			# Fade the loading screen away.
			load_finished.emit()

func _place_player_at_spawn() -> void:
	if target_spawn_id.is_empty():
		print("No spawn ID requested.")
		return

	var player := (
		get_tree().get_first_node_in_group("player")
		as Node2D
	)

	if player == null:
		print("ERROR: Player not found.")
		return

	print("Looking for spawn ID: ", target_spawn_id)

	var spawn_points = (
		get_tree().get_nodes_in_group(
			"scene_spawn_points"
		)
	)

	print("Spawn points found: ", spawn_points.size())

	for node in spawn_points:
		var spawn := node as SceneSpawnPoint

		if spawn == null:
			continue

		print("Checking spawn: ", spawn.spawn_id)

		if spawn.spawn_id == target_spawn_id:
			player.global_position = (
				spawn.global_position
			)

			print(
				"Moved Cal to: ",
				spawn.global_position
			)

			target_spawn_id = &""
			return

	print(
		"ERROR: No matching spawn point for ",
		target_spawn_id
	)
