@tool
class_name Spring
extends Node2D

@export var debug_draw: bool = false
@export var preview_power: float = 32.0
@export_tool_button(&"Preview Spring") var preview: Callable = _preview_spring

@export var process_in_physics: bool = false

@export var spring_constant: float = 200
@export var damping_constant: float = 12

var _spring_power: float = 0.0
var displacement: float = 0.0


func _draw() -> void:
	if debug_draw:
		draw_circle(Vector2(0, displacement), 2.0, Color.WHITE)


func _process(_delta: float) -> void:
	if debug_draw:
		queue_redraw()
	
	if process_in_physics:
		return
	
	if not is_zero_approx(_spring_power):
		update_spring()
	else:
		_spring_power = 0
		displacement = 0


func _physics_process(_delta: float) -> void:
	if not process_in_physics:
		return
	
	if not is_zero_approx(_spring_power):
		update_spring()
	else:
		_spring_power = 0
		displacement = 0


func _preview_spring() -> void:
	start_spring(preview_power)


func start_spring(power: float) -> void:
	_spring_power = power


func update_spring() -> void:
	var _damping_ratio: float = damping_constant / (2 * sqrt(spring_constant))
	
	var force: float = (-spring_constant * displacement) + (damping_constant * _spring_power)
	_spring_power -= force
	displacement -= _spring_power
