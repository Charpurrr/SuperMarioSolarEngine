extends ToolMenu


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_curve_draw_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%LineDraw.button_pressed = false
		%CurveSubMenu.show()
	else:
		%CurveSubMenu.hide()


func _on_line_draw_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%CurveDraw.button_pressed = false
