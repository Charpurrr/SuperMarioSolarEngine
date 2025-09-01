@tool
class_name CurveButton
extends DraggableButton
## An editor widget button meant for defining curve angles.

@export var button_l: DraggableButton
@export var button_r: DraggableButton
@export var handle_line: Line2D


func _process(delta: float) -> void:
	super(delta)

	if button_r.held_down:
		handle_line.set_point_position(2, button_r.position)
		handle_line.set_point_position(0, -button_r.position)
		button_l.set_position(-button_r.position)
	if button_l.held_down:
		handle_line.set_point_position(0, button_l.position)
		handle_line.set_point_position(2, -button_l.position)
		button_r.set_position(-button_l.position)
