class_name GuideNetwork
extends Node2D


@export var lighting_system: LightingSystem

@export var starting_checkpoint: GuideCheckpoint
@export var target_checkpoint: GuideCheckpoint


var astar := AStar2D.new()

var checkpoints: Array[GuideCheckpoint] = []

var current_checkpoint: GuideCheckpoint


func _ready() -> void:
	print("GUIDE NETWORK STARTED")
	_collect_checkpoints()
	print("Found checkpoints: ", checkpoints.size())
	_build_graph()
	_connect_checkpoints()

	current_checkpoint = starting_checkpoint
	print("Starting checkpoint: ", starting_checkpoint)
	print("Target checkpoint: ", target_checkpoint)
	print("Lighting system: ", lighting_system)
	update_guide()

func _collect_checkpoints() -> void:
	checkpoints.clear()

	for child in get_children():
		if child is GuideCheckpoint:
			checkpoints.append(child)

func _build_graph() -> void:
	astar.clear()

	# Add checkpoints as AStar points.
	for checkpoint in checkpoints:

		var id := checkpoint.get_instance_id()

		astar.add_point(
			id,
			checkpoint.global_position
		)

	# Connect neighbors.
	for checkpoint in checkpoints:

		var from_id := checkpoint.get_instance_id()

		for neighbor in checkpoint.neighbors:

			if neighbor == null:
				continue

			var to_id := neighbor.get_instance_id()

			if not astar.has_point(to_id):
				push_warning(
					"Neighbor is not part of this GuideNetwork: "
					+ str(neighbor)
				)

				continue

			if not astar.are_points_connected(
				from_id,
				to_id
			):
				astar.connect_points(
					from_id,
					to_id,
					true
				)

func _connect_checkpoints() -> void:
	for checkpoint in checkpoints:

		checkpoint.reached.connect(
			_on_checkpoint_reached
		)

func _on_checkpoint_reached(
	checkpoint: GuideCheckpoint
) -> void:

	current_checkpoint = checkpoint

	print(
		"Reached checkpoint: ",
		checkpoint.checkpoint_id
	)

	update_guide()

func update_guide() -> void:
	print("Updating guide...")

	if current_checkpoint == null:
		print("ERROR: current checkpoint is null")
		return

	if target_checkpoint == null:
		print("ERROR: target checkpoint is null")
		return

	if lighting_system == null:
		print("ERROR: lighting system is null")
		return

	var start_id := current_checkpoint.get_instance_id()
	var target_id := target_checkpoint.get_instance_id()

	print("Start ID: ", start_id)
	print("Target ID: ", target_id)

	var path := astar.get_point_path(
		start_id,
		target_id
	)

	print("AStar path: ", path)
	print("Path size: ", path.size())

	lighting_system.show_guide_path(path)
