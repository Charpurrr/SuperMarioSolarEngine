class_name Tool
extends State
## Editor tool.

## The visual icon of the tool.
@export var mouse_icon: Texture2D
## The shape of the tool.
@export var mouse_shape: Input.CursorShape
## The hotspot location of the cursor.
## [br][br][i]The hotspot is the point in the cursor that interacts with other elements on the screen.[/i]
@export var hotspot: Vector2i


func trigger_enter(handover):
	super(handover)

	Input.set_custom_mouse_cursor(mouse_icon, mouse_shape, hotspot)
