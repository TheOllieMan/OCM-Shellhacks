class_name DestinationBeacon
extends Node2D


@onready var outer_light: PointLight2D = $OuterLight
@onready var inner_light: PointLight2D = $InnerLight


@export var outer_energy: float = 0.18
@export var inner_energy: float = 0.12

@export_range(0.0, 0.15, 0.01)
var breathe_amount: float = 0.025

@export_range(0.0, 2.0, 0.05)
var breathe_speed: float = 0.6


var time: float = 0.0


func _ready() -> void:
	visible = false


func _process(delta: float) -> void:
	if not visible:
		return

	time += delta * breathe_speed

	var breathe: float = (
		1.0
		+ sin(time) * breathe_amount
	)

	outer_light.energy = (
		outer_energy * breathe
	)

	inner_light.energy = (
		inner_energy * breathe
	)


func show_at(world_position: Vector2) -> void:
	global_position = world_position
	time = 0.0
	visible = true


func hide_beacon() -> void:
	visible = false
