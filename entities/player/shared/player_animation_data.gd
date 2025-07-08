@tool
class_name PStateAnimData
extends Resource
## A class that contains animation data for a [PlayerState].

## Which animation this state will use from the doll's animations.
var animation: String = "":
	set(val):
		animation = val

		if preview and is_instance_valid(doll):
			doll.animation = val
## Which frame of the animation is being edited.
var frame: int = 0:
	set(val):
		if not animation.is_empty() and is_instance_valid(doll):
			doll.animation = animation

			frame = val
			frame = clamp(frame, 0, doll.sprite_frames.get_frame_count(animation) - 1)

			doll.frame = frame
			doll.offset = frame_offset

			notify_property_list_changed()
var frame_offset := Vector2i.ZERO:
	get():
		return frame_offsets.get_or_add(frame, Vector2i.ZERO)
	set(val):
		frame_offset = val
		frame_offsets.set(frame, val)

		if preview and is_instance_valid(doll):
			doll.offset = val
## Which FLUDD frame this state frame will use.
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
			doll.offset = frame_offset

		doll.animation = animation

		preview = val
		notify_property_list_changed()
var preview_fludd: bool = false
var doll: AnimatedSprite2D
var animation_list: PackedStringArray

var frame_offsets: Dictionary[int, Vector2i]
var frame_fludd: Dictionary[int, String]
var frame_fludd_offset: Dictionary[int, Vector2i]


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
			"name": "frame",
			"type": TYPE_INT,
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
			]
		)

	properties.append_array(
		[
			{
				"name": "Frame Specifications (Frame %d)" % frame,
				"type": TYPE_NIL,
				"usage": PROPERTY_USAGE_GROUP,
			},
			{
				"name": "frame_offset",
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
		]
	)

	return properties
