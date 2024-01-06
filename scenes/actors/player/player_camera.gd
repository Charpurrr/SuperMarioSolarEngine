class_name PlayerCamera
extends Node2D
## Camera specifically for player characters.


@export var enabled = true

@export_category("Camera Transform")
@export var zoom: float = 1
@export var offset: Vector2

@onready var player: CharacterBody2D = owner
@onready var viewport: Viewport = get_viewport()

## Center of the viewport.
@onready var center_offset: Vector2

@export_category("Camera Movement")
## How far the camera gets pushed past the center of the screen 
## while continuously walking in one direction.
@export var x_push: int

## How many frames the player continuously has to move in a direction
## for the camera to start pushing past the center of the screen.
@export var x_push_time: int
var x_push_timer: int


func _physics_process(_delta):
	if not enabled: return

	var trans := Transform2D.IDENTITY

	center_offset = DisplayServer.window_get_size() / 2
	trans = trans.scaled(Vector2.ONE * zoom)

	#if player.vel.x != 0:
		#print(player.input.get_x_dir())

	#trans.origin = (-player.position * zoom) + center_offset
	# Disable camera following Mario on Y axis.
	trans.origin = (Vector2(-player.position.x, 0) * zoom) + center_offset + offset

	viewport.canvas_transform = trans
