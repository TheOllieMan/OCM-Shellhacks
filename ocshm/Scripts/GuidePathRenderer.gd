class_name GuidePathRenderer
extends MultiMeshInstance2D


@export var light_spacing: float = 48.0



func set_path(path: PackedVector2Array) -> void:
	var samples := _sample_path(path, light_spacing)

	print("Original path: ", path)
	print("Generated light positions: ", samples)

	_build_multimesh(samples)

func _build_multimesh(samples: PackedVector2Array) -> void:
	var new_multimesh := MultiMesh.new()

	new_multimesh.transform_format = MultiMesh.TRANSFORM_2D

	# This allows us to send extra information
	# to each individual light.
	new_multimesh.use_custom_data = true

	var quad := QuadMesh.new()
	quad.size = Vector2(40, 40)

	new_multimesh.mesh = quad
	new_multimesh.instance_count = samples.size()

	for i in range(samples.size()):
		var transform := Transform2D.IDENTITY
		transform.origin = samples[i]

		new_multimesh.set_instance_transform_2d(
			i,
			transform
		)

		var progress := 0.0

		if samples.size() > 1:
			progress = float(i) / float(samples.size() - 1)

		new_multimesh.set_instance_custom_data(
			i,
			Color(progress, 0.0, 0.0, 1.0)
		)

	multimesh = new_multimesh


func set_global_path(world_path: PackedVector2Array) -> void:

	var local_path := PackedVector2Array()

	for world_position in world_path:
		local_path.append(
			to_local(world_position)
		)

	set_path(local_path)



func _sample_path(
	path: PackedVector2Array,
	spacing: float
) -> PackedVector2Array:

	var samples := PackedVector2Array()

	if path.is_empty():
		return samples

	# Always place one sample at the start.
	samples.append(path[0])

	if path.size() == 1:
		return samples

	var distance_until_next := spacing

	for i in range(path.size() - 1):

		var start := path[i]
		var end := path[i + 1]

		var segment := end - start
		var segment_length := segment.length()

		if segment_length <= 0.001:
			continue

		var direction := segment / segment_length
		var travelled := 0.0

		while travelled + distance_until_next <= segment_length:

			travelled += distance_until_next

			var sample_position := (
				start
				+ direction * travelled
			)

			samples.append(sample_position)

			distance_until_next = spacing

		# Carry leftover distance into the next segment.
		distance_until_next -= segment_length - travelled

	# Make sure the destination itself gets a light.
	if samples[-1].distance_to(path[-1]) > spacing * 0.35:
		samples.append(path[-1])

	return samples
	
