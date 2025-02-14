class_name PlayerCamera
extends Camera2D

@export var zoom_in_sfx: SFXLayer
@export var zoom_out_sfx: SFXLayer

@export var zoom_max: float = 200
@export var zoom_min: float = 50

## The current camera zoom in percentage.
## (Note: higher zoom percentage means you can see more level.)
var zoom_percentage: float = 100

## The zoom value the camera gets tweened to.
var target_zoom: float = 100


func _physics_process(delta: float) -> void:
	zoom_percentage = lerp(zoom_percentage, target_zoom, delta * 5)

	var zoom_factor: float = 1 / (zoom_percentage / 100)

	zoom = Vector2(zoom_factor, zoom_factor)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"camera_zoom_in"):
		if target_zoom != zoom_min:
			zoom_in_sfx.play_sfx_at(self)

		if target_zoom <= 100:
			target_zoom -= 25
		else:
			target_zoom -= 50
	if event.is_action_pressed(&"camera_zoom_out"):
		if target_zoom != zoom_max:
			zoom_out_sfx.play_sfx_at(self)

		if target_zoom < 100:
			target_zoom += 25
		else:
			target_zoom += 50

	target_zoom = clamp(target_zoom, zoom_min, zoom_max)
