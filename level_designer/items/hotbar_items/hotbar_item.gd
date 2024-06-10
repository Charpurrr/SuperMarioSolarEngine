class_name HotbarItem
extends Button
## Hotbar button for an item.


## How fast the progress bar for pinning an item fills up (in seconds.)
@export var pin_hold_time: float
## How fast the progress bar for pinning an item empties out (in seconds.)
@export var pîn_release_time: float

@export_category(&"References")
@export var item_icon: TextureRect
@export var pin_progress: ProgressBar
@export var pin_icon: Sprite2D

@onready var hotbar: Hotbar = get_parent()

@onready var _tween = null

var item_data: EditorItem
var pinned: bool


func create_data(data: EditorItem):
	item_icon.texture = data.icon_texture
	item_icon.visible = true
	item_data = data


func _gui_input(event):
	if event.is_action_pressed("e_clear_hotbar_item"):
		_clear_data()

	if event.is_action_pressed("e_pin_hotbar_item"):
		_tween_inrease()

	if event.is_action_released("e_pin_hotbar_item"):
		_tween_decrease()


func _tween_inrease():
	if _tween != null: _tween.kill()

	_tween = get_tree().create_tween()
	_tween.set_ease(Tween.EASE_IN)

	_tween.tween_property(pin_progress, "value", 100.0, pin_hold_time)
	_tween.connect(&"finished", _pin_unpin_item)


func _tween_decrease():
	if _tween != null: _tween.kill()

	_tween = get_tree().create_tween()
	_tween.tween_property(pin_progress, "value", 0.0, pîn_release_time)


func _pin_unpin_item():
	_tween.kill()
	pin_progress.value = 0

	pinned = !pinned
	pin_icon.visible = pinned

	if pinned == true:
		hotbar.pin_item(self)
	else:
		hotbar.unpin_item(self)


func _notification(what):
	if what == NOTIFICATION_DRAG_END and not item_icon.visible:
		if get_viewport().gui_is_drag_successful():
			_clear_data()
		else:
			item_icon.visible = true

	if what == NOTIFICATION_MOUSE_EXIT:
		_tween_decrease()


func _get_drag_data(_at_position):
	if pinned: return
	if item_data == null: return null

	_tween_decrease()

	var preview_texture := TextureRect.new()

	preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview_texture.texture = item_data.icon_texture
	preview_texture.size = item_icon.size * 1.2

	preview_texture.position = -preview_texture.size / 2

	var preview := Control.new()

	preview.add_child(preview_texture)

	set_drag_preview(preview)
	item_icon.visible = false

	return item_data


func _can_drop_data(_at_position, data):
	return data is EditorItem and not pinned


func _drop_data(_at_position, data):
	create_data(data)


func _clear_data():
	if pinned: return

	item_icon.texture = null
	item_data = null
