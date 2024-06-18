extends PropertyDisplay

func property_changed(new_value: Variant):
	new_value = new_value as Vector2
	preview.scale = new_value
