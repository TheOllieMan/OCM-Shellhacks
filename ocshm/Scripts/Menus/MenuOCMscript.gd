extends Sprite2D
@export var button_frames := {"Star*": 0, "Opti*": 2, "Quit*": 5}
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"


func _ready() -> void:
	for n in button_frames:
		
		var b = get_tree().current_scene.find_child(n)
		if b:
			b.mouse_entered.connect(_set_frame.bind(button_frames[n]))
			
			
		else:
			print("Can't find a button called: ", n)

func _set_frame(f: int) -> void:
	audio_stream_player_2d.play()
	frame = f
