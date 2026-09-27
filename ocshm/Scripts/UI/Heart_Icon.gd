class_name HeartIcon
extends Sprite2D


var current_units: int = 2

var animation_version: int = 0


func set_health_units(
	units: int,
	animate: bool = true
) -> void:

	units = clampi(
		units,
		0,
		2
	)

	var target_frame: int = _units_to_frame(
		units
	)

	current_units = units

	animation_version += 1
	var version: int = animation_version

	if not animate:
		frame = target_frame
		return

	await _animate_to_frame(
		target_frame,
		version
	)


func _units_to_frame(
	units: int
) -> int:

	match units:
		2:
			return 0

		1:
			return 2

		_:
			return 4


func _animate_to_frame(
	target_frame: int,
	version: int
) -> void:

	while frame != target_frame:

		if version != animation_version:
			return

		if frame < target_frame:
			frame += 1
		else:
			frame -= 1

		await get_tree().create_timer(
			0.06
		).timeout
