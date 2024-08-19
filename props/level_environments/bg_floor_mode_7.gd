extends TextureRect

@onready var environment: LevelEnvironment = get_parent()

@export var scroll_factor : float = 1
var cam_x : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	cam_x = -environment.camera.get_screen_center_position().x
	
	material.set_shader_parameter("mapPosition", Vector3(-cam_x/(10000*scroll_factor), -2, 0))
