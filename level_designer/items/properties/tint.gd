extends PropertyDisplay


func property_changed(new_value: Variant):
	new_value = new_value as Color
	preview_display.modulate = new_value
