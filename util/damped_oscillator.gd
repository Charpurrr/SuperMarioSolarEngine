@tool
class_name DampedOscillator
extends Node2D

@export var debug_draw: bool = false
@export var preview_power: float = 20.0
@export_tool_button(&"Preview") var preview: Callable = _preview

@export var process_in_physics: bool = false

## How much the spring jiggles.
@export var spring_constant: float = .2
## How quickly the spring returns to 0.
@export var damping: float = .15

var velocity: float = 0.0
var displacement: float = 0.0


func _draw() -> void:
	if debug_draw:
		draw_circle(Vector2(0, displacement), 2.0, Color.WHITE)


func _process(_delta: float) -> void:
	if debug_draw:
		queue_redraw()
	
	if process_in_physics:
		return
	
	if not is_zero_approx(velocity):
		_update()
	else:
		velocity = 0
		displacement = 0


func _physics_process(_delta: float) -> void:
	if not process_in_physics:
		return
	
	if not is_zero_approx(velocity):
		_update()
	else:
		velocity = 0
		displacement = 0


func _preview() -> void:
	start(preview_power)


func start(power: float) -> void:
	velocity = power


func _update() -> void:
	# F = -kx 
	var force: float = (-spring_constant * displacement) + (damping * velocity)
	# since we're assuming mass to be 1 here we can just subtract the force as we would an acceleration
	velocity -= force
	displacement -= velocity
