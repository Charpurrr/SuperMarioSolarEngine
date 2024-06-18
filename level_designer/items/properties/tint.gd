extends PropertyDisplay


func property_changed(new_value: Variant):
	new_value = new_value as Color
	preview.modulate = new_value
