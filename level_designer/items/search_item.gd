class_name SearchItem
extends Button
## An item within the search item menu.


@onready var texture_rect = $TextureRect

var item_data: EditorItem


func create_item(data: EditorItem):
	texture_rect.texture = data.icon_texture
	item_data = data


func _get_drag_data(_at_position):
	var preview_texture := TextureRect.new()
	preview_texture.texture = item_data.icon_texture
	preview_texture.size = texture_rect.size * 1.2
	preview_texture.position = -preview_texture.size / 2

	var preview := Control.new()
	preview.add_child(preview_texture)

	set_drag_preview(preview)

	return item_data
