class_name Util
## Provides useful functions that you can call using [code]Util.function_name[/code].


## Resets the mouse cursor graphic to that defined in the project settings.
static func set_cursor_to_default():
	var default_cursor_image: Resource = load(
		ProjectSettings.get_setting("display/mouse_cursor/custom_image")
		)

	Input.set_custom_mouse_cursor(
		default_cursor_image,
		Input.CURSOR_ARROW,
		ProjectSettings.get_setting("display/mouse_cursor/custom_image_hotspot")
	)
