class_name HotbarItem
extends Button
## Hotbar button for an item.


@onready var texture_rect = $TextureRect

var item_data: EditorItem


func _notification(what):
	if what == NOTIFICATION_DRAG_END and not texture_rect.visible:
		if get_viewport().gui_is_drag_successful():
			_clear_data()
		else:
			texture_rect.visible = true


func _get_drag_data(_at_position):
	if item_data == null: return null

	var preview_texture := TextureRect.new()

	preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_texture.texture = item_data.icon_texture
	preview_texture.size = texture_rect.size * 1.2

	preview_texture.position = -preview_texture.size / 2

	var preview := Control.new()

	preview.add_child(preview_texture)

	set_drag_preview(preview)
	texture_rect.visible = false

	return item_data


func _can_drop_data(_at_position, data):
	return data is EditorItem


func _drop_data(_at_position, data):
	texture_rect.texture = data.icon_texture
	texture_rect.visible = true
	item_data = data


func _clear_data():
	texture_rect.texture = null
	item_data = null
