extends HitboxComponent

var dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	super._ready()


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		print("WEAPON CLICKED")
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
		else:
			dragging = false
			

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			dragging = false


func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
