class_name HotbarItem
extends Button
## Hotbar button for an item.


@onready var texture_rect = $TextureRect

var item_data: EditorItem


func _get_drag_data(_at_position):
	var preview_texture := TextureRect.new()
	preview_texture.texture = item_data.icon_texture
	preview_texture.size = texture_rect.size * 1.2
	preview_texture.position = -preview_texture.size / 2

	var preview := Control.new()
	preview.add_child(preview_texture)

	set_drag_preview(preview)
	#_clear_data()

	return item_data



func _can_drop_data(_at_position, data):
	return data is EditorItem


func _drop_data(_at_position, data):
	texture_rect.texture = data.icon_texture
	item_data = data


func _clear_data():
	texture_rect.texture = null
	item_data = null
