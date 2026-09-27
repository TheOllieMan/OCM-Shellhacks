extends Node


signal keys_changed(key_count: int)


var collected_keys: Array[StringName] = []
func key_count() -> int:
	return collected_keys.size()

func collect_key(key_id: StringName) -> bool:
	if has_key(key_id):
		return false

	collected_keys.append(key_id)

	keys_changed.emit(
		collected_keys.size()
	)

	print(
		"Key collected: ",
		key_id,
		" | Total keys: ",
		collected_keys.size()
	)

	return true


func has_key(key_id: StringName) -> bool:
	return key_id in collected_keys


func get_key_count() -> int:
	return collected_keys.size()


func has_all_keys() -> bool:
	return collected_keys.size() >= 3


func reset_run() -> void:
	collected_keys.clear()
	keys_changed.emit(0)
