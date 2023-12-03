class_name PlayerCamera
extends Node2D
## Camera specifically for player characters.


@export var enabled = true

@export_category("Camera Transform")
@export var zoom: float = 1
@export var offset: Vector2

@onready var player: CharacterBody2D = owner
@onready var viewport: Viewport = get_viewport()

@onready var center_offset: Vector2


func _physics_process(_delta):
	if not enabled: return

	var trans := Transform2D.IDENTITY

	center_offset = DisplayServer.window_get_size() / 2

	trans = trans.scaled(Vector2.ONE * zoom)
	trans.origin = (-player.position * zoom) + center_offset

	viewport.canvas_transform = trans
