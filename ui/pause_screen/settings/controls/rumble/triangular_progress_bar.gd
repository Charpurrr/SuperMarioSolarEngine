extends ColorRect


func _notification(what):
	if what == NOTIFICATION_RESIZED:
		material = material as ShaderMaterial
		material.set_shader_parameter(&"bounding_box", size)
