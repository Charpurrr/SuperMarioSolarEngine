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
			frame = val
			frame = wrapi(val, 0, doll.sprite_frames.get_frame_count(animation))

			notify_property_list_changed()

		if preview:
			doll.animation = animation

			doll.frame = frame
			doll.offset = frame_offset
## Specific offset for this frame.
var frame_offset := Vector2i.ZERO:
	set(val):
		frame_offset = val
		frame_offsets.set(frame, val)

		if preview and is_instance_valid(doll):
			doll.offset = val
	get():
		return frame_offsets.get(frame, Vector2i.ZERO)
## Which FLUDD frame this state frame will use.
var fludd_animation: String = "default"
var fludd_offset := Vector2i.ZERO
## Toggle previewing your frame and it's offsets.
var preview: bool = false:
	set(val):
		if animation.is_empty():
			printerr("Cant preview an animation if none is selected.")
			return

		# Extra check we need to add because resources get cached at startup.
		# Only relevant in game hence the editor hint check.
		if not Engine.is_editor_hint() and not is_instance_valid(get_local_scene()):
			return

		if not is_instance_valid(doll):
			printerr("Couldn't find the AnimatedSprite2D.")
			return

		if val == false:
			doll.offset = Vector2i.ZERO
		else:
			doll.offset = frame_offset

		doll.animation = animation
		doll.frame = frame

		if doll.has_meta(&"last_previewed"):
			var last = doll.get_meta(&"last_previewed")
			if is_instance_valid(last):
				last.preview_private = false

		preview_private = val
		doll.set_meta(&"last_previewed", self)

		notify_property_list_changed()
	get():
		return preview_private
## Used to avoid infinite recursion when disabling other preview toggles.
var preview_private: bool = false
## Toggle previewing your frame's FLUDD variant and it's offsets.
var preview_fludd: bool = false

@export_storage var doll: AnimatedSprite2D
## Populated in the initialiser only for editor purposes. Not used in-game.
var animation_list: PackedStringArray

## List of offsets connected to frames.
## Used for referencing these values when you need them in regular code.
@export_storage var frame_offsets: Dictionary[int, Vector2i]
## List of FLUDD animations connected to frames.
## Used for referencing these values when you need them in regular code.
@export_storage var frame_fludd: Dictionary[int, String]
## List of FLUDD offsets connected to frames.
## Used for referencing these values when you need them in regular code.
@export_storage var frame_fludd_offset: Dictionary[int, Vector2i]


func _init() -> void:
	call_deferred(&"setup")


func setup() -> void:
	# We only need to populate the animation list while editing the data resource
	# in the editor. It's no longer relevant when we're running the game.
	if not Engine.is_editor_hint():
		return
	
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
