class_name WindowSizer

const MAX_SCALE: int = 3

static var default_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)

## The last window scale value that wasn't a fullscreen.[br]
## Useful for reverting back to a window scale when toggling fullscreen
## using the hotkey.
static var last_none_fs: int = 1


static func set_win_size(window_scale):
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = default_size * (window_scale + 1)

	# Set fullscreen if a window scale exceeds the bounds of the screen.
	if window_size > screen_size:
		window_scale = MAX_SCALE

	if window_scale != MAX_SCALE:
		last_none_fs = window_scale

		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(window_size)
	
		var window_pos: Vector2i = (screen_size - window_size) / 2
		DisplayServer.window_set_position(window_pos)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	#Singleton.EditorSavedSettings.stored_window_scale = window_scale
