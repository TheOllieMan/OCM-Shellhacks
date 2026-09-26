class_name LightingSystem
extends Node2D


@export var guide_lamp_scene: PackedScene


@onready var lamp_container: Node2D = (
	$LampContainer
)

@onready var destination_beacon: DestinationBeacon = (
	$DestinationBeacon
)


@export_range(100.0, 320.0, 10.0)
var lamp_spacing: float = 180.0

@export_range(1, 12, 1)
var max_active_lamps: int = 8


@export_range(0.0, 1.0, 0.05)
var pulse_speed: float = 0.20

@export_range(0.01, 0.5, 0.01)
var pulse_width: float = 0.18

@export_range(0.0, 1.0, 0.05)
var pulse_boost: float = 0.35


@export_range(0.0, 100.0, 1.0)
var corner_radius: float = 35.0

@export_range(2, 12, 1)
var corner_samples: int = 5


var lamp_pool: Array[GuideLamp] = []

var active_lamp_count: int = 0

var animation_time: float = 0.0


func _process(delta: float) -> void:
	if active_lamp_count <= 0:
		return


	animation_time += delta


	#
	# Pulse travels:
	#
	# -0.15 → 1.15
	#
	# then restarts.
	#
	var pulse_position: float = (
		fmod(
			animation_time * pulse_speed,
			1.30
		)
		- 0.15
	)


	for i in range(active_lamp_count):

		var lamp: GuideLamp = lamp_pool[i]

		var distance_to_pulse: float = abs(
			lamp.path_progress
			- pulse_position
		)

		var pulse: float = (
			1.0
			-
			smoothstep(
				0.0,
				pulse_width,
				distance_to_pulse
			)
		)

		var intensity: float = (
			1.0
			+
			pulse * pulse_boost
		)

		lamp.set_intensity(
			intensity
		)

func _round_path(
	path: PackedVector2Array
) -> PackedVector2Array:

	if path.size() < 3:
		return path

	var result := PackedVector2Array()

	result.append(path[0])

	for i in range(1, path.size() - 1):

		var previous: Vector2 = path[i - 1]
		var corner: Vector2 = path[i]
		var next: Vector2 = path[i + 1]

		var incoming: Vector2 = previous - corner
		var outgoing: Vector2 = next - corner

		var incoming_length: float = incoming.length()
		var outgoing_length: float = outgoing.length()

		if incoming_length <= 0.001 \
		or outgoing_length <= 0.001:

			result.append(corner)
			continue

		var radius: float = minf(
			corner_radius,
			minf(
				incoming_length * 0.25,
				outgoing_length * 0.25
			)
		)

		var entry: Vector2 = (
			corner
			+ incoming.normalized() * radius
		)

		var exit: Vector2 = (
			corner
			+ outgoing.normalized() * radius
		)

		result.append(entry)

		for sample_index in range(
			1,
			corner_samples + 1
		):

			var t: float = (
				float(sample_index)
				/
				float(corner_samples + 1)
			)

			var inverse_t: float = 1.0 - t

			var point: Vector2 = (
				inverse_t * inverse_t * entry
				+
				2.0 * inverse_t * t * corner
				+
				t * t * exit
			)

			result.append(point)

		result.append(exit)

	result.append(path[-1])

	return result




func clear_guide_path() -> void:

	for lamp in lamp_pool:
		lamp.deactivate()


	active_lamp_count = 0


	if destination_beacon != null:
		destination_beacon.hide_beacon()


func _get_point_at_distance(
	path: PackedVector2Array,
	target_distance: float
) -> Vector2:

	if path.is_empty():
		return Vector2.ZERO


	if path.size() == 1:
		return path[0]


	var travelled: float = 0.0


	for i in range(
		path.size() - 1
	):

		var start: Vector2 = path[i]
		var end: Vector2 = path[i + 1]


		var segment_length: float = (
			start.distance_to(end)
		)


		if (
			travelled
			+ segment_length
			>= target_distance
		):

			if segment_length <= 0.001:
				return end


			var remaining: float = (
				target_distance
				- travelled
			)


			var t: float = (
				remaining
				/
				segment_length
			)


			return start.lerp(
				end,
				t
			)


		travelled += segment_length


	return path[-1]

func set_destination(
	world_position: Vector2
) -> void:

	destination_beacon.show_at(
		world_position
	)


func _sample_lamp_positions(
	path: PackedVector2Array,
	spacing: float
) -> PackedVector2Array:

	var result := PackedVector2Array()


	var total_length: float = (
		_get_path_length(path)
	)


	if total_length <= 0.001:
		return result


	#
	# Don't start directly under the checkpoint.
	#
	var start_offset: float = minf(
		spacing * 0.35,
		total_length * 0.25
	)


	#
	# Leave space for the destination beacon.
	#
	var end_margin: float = minf(
		spacing * 0.35,
		total_length * 0.20
	)


	var distance: float = start_offset


	while (
		distance
		<
		total_length - end_margin
		and
		result.size() < max_active_lamps
	):

		result.append(
			_get_point_at_distance(
				path,
				distance
			)
		)

		distance += spacing


	#
	# Very short routes should still
	# receive one lamp.
	#
	if result.is_empty():
		result.append(
			_get_point_at_distance(
				path,
				total_length * 0.5
			)
		)


	return result


func show_guide_path(
	world_path: PackedVector2Array
) -> void:

	if world_path.size() < 2:
		clear_guide_path()
		return


	var visual_path: PackedVector2Array = (
		_round_path(world_path)
	)


	var total_length: float = (
		_get_path_length(
			visual_path
		)
	)


	if total_length <= 0.001:
		clear_guide_path()
		return


	#
	# Prevent giant routes from producing
	# dozens of PointLight2Ds.
	#
	var effective_spacing: float = maxf(
		lamp_spacing,
		total_length
		/
		float(max_active_lamps)
	)


	var positions: PackedVector2Array = (
		_sample_lamp_positions(
			visual_path,
			effective_spacing
		)
	)


	_ensure_lamp_pool(
		positions.size()
	)


	active_lamp_count = positions.size()


	for i in range(
		active_lamp_count
	):

		var progress: float = 0.0

		if active_lamp_count > 1:
			progress = (
				float(i)
				/
				float(
					active_lamp_count - 1
				)
			)


		lamp_pool[i].configure(
			positions[i],
			progress
		)


	#
	# Turn unused lamps off.
	#
	for i in range(
		active_lamp_count,
		lamp_pool.size()
	):
		lamp_pool[i].deactivate()
	print("Total route length: ", total_length)
	print("Effective lamp spacing: ", effective_spacing)
	print("Lamp positions count: ", positions.size())
	print("Lamp positions: ", positions)


func _ensure_lamp_pool(
	required_count: int
) -> void:

	while lamp_pool.size() < required_count:

		if guide_lamp_scene == null:
			push_error(
				"LightingSystem: GuideLamp scene is missing."
			)
			return


		var instance: Node = (
			guide_lamp_scene.instantiate()
		)


		var lamp := instance as GuideLamp


		if lamp == null:
			push_error(
				"GuideLamp scene root must use GuideLamp.gd."
			)

			instance.queue_free()
			return


		lamp_container.add_child(
			lamp
		)

		lamp.deactivate()

		lamp_pool.append(
			lamp
		)
		


func _get_path_length(
	path: PackedVector2Array
) -> float:

	var total: float = 0.0


	for i in range(
		path.size() - 1
	):

		total += (
			path[i].distance_to(
				path[i + 1]
			)
		)


	return total
