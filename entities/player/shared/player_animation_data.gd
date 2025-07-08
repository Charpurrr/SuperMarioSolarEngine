@tool
class_name PStateAnimData
extends Resource
## A class that contains animation data for a [PlayerState].

var animation: String = "":
	set(val):
		animation = val

		if preview and is_instance_valid(doll):
			doll.animation = val
var animation_offset := Vector2i.ZERO
var fludd_animation: String = "default"
var fludd_offset := Vector2i(0, 0)
var preview: bool = false:
	set(val):
		if animation.is_empty():
			printerr("Cant preview an animation if none is selected.")
			return

		if not is_instance_valid(doll):
			printerr("Couldn't find the AnimatedSprite2D.")
			return

		if val == false:
			doll.offset = Vector2i.ZERO
		else:
			doll.offset = animation_offset

		doll.animation = animation

		preview = val
		notify_property_list_changed()
var preview_fludd: bool = false
var frame: int = 0:
	set(val):
		if is_instance_valid(doll):
			doll.animation = animation

			frame = val
			frame = clamp(frame, 0, doll.sprite_frames.get_frame_count(animation) - 1)
			doll.frame = frame

var doll: AnimatedSprite2D
var animation_list: PackedStringArray


func _init() -> void:
	doll = get_local_scene().doll
	animation_list = doll.sprite_frames.get_animation_names()


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [
		{
			"name": "animation",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(animation_list),
			"usage": PROPERTY_USAGE_DEFAULT,
		},
		{
			"name": "animation_offset",
			"type": TYPE_VECTOR2I,
			"usage": PROPERTY_USAGE_DEFAULT,
		},
		{
			"name": "fludd_animation",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "default",
			"usage": PROPERTY_USAGE_DEFAULT,
		},
		{
			"name": "fludd_offset",
			"type": TYPE_VECTOR2I,
			"usage": PROPERTY_USAGE_DEFAULT,
		},
		{
			"name": "preview",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		},
	]

	if preview:
		properties.append_array(
			[
				{
					"name": "preview_fludd",
					"type": TYPE_BOOL,
					"usage": PROPERTY_USAGE_DEFAULT,
				},
				{
					"name": "frame",
					"type": TYPE_INT,
					"usage": PROPERTY_USAGE_DEFAULT,
				},
			]
		)

	return properties
