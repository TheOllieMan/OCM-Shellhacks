class_name Door
extends Area2D


@export_file("*.tscn")
var destination_scene: String

@export var destination_spawn_id: StringName


@onready var prompt_layer: CanvasLayer = $PromptLayer


var player_inside: bool = false
var transitioning: bool = false


func _ready() -> void:
	prompt_layer.visible = false

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if not player_inside:
		return

	if transitioning:
		return

	if Input.is_action_just_pressed("interact"):
		_enter_door()


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player_inside = true
	prompt_layer.visible = true


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player_inside = false
	prompt_layer.visible = false


func _enter_door() -> void:
	if destination_scene.is_empty():
		push_error("Door has no destination scene.")
		return

	transitioning = true
	prompt_layer.visible = false

	SceneLoader.load_scene(destination_scene, destination_spawn_id)
