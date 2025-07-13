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
		if animation.is_empty():
			printerr("No animation selected.")
			return
		if not is_instance_valid(doll):
			printerr("Couldn't find the doll AnimatedSprite2D.")
			return
		if not is_instance_valid(doll.sprite_frames):
			printerr("Couldn't find the doll's sprite frames resource.")
			return
		if not doll.sprite_frames.has_animation(animation):
			printerr("Couldn't find animation '%s' in the doll's sprite frames resource." % animation)
			return

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
var fludd_animation: String = "rot_y000":
	set(val):
		fludd_animation = val

		if preview_fludd and is_instance_valid(fludd_f) and is_instance_valid(fludd_b):
			fludd_f.animation = val
			fludd_b.animation = val
var fludd_offset := Vector2i.ZERO:
	set(val):
		fludd_offset = val
		frame_fludd_offsets.set(frame, val)

		if preview_fludd and is_instance_valid(fludd_b) and is_instance_valid(fludd_f):
			fludd_b.offset = val
			fludd_f.offset = val
	get():
		return frame_fludd_offsets.get(frame, Vector2i.ZERO)
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
			printerr("Couldn't find the doll AnimatedSprite2D.")
			return

		if val == false:
			doll.offset = Vector2i.ZERO
			preview_fludd = false
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
var preview_fludd: bool = false:
	set(val):
		preview_fludd = val

		if not is_instance_valid(fludd_f) and not is_instance_valid(fludd_b):
			printerr(
			"Missing FLUDD sprite! Make sure you have 2 seperate sprites for a front and back layer of FLUDD."
			)
			return

		fludd_b.visible = val
		fludd_f.visible = val

		if val == false:
			fludd_b.offset = Vector2i.ZERO
			fludd_f.offset = Vector2i.ZERO
		else:
			fludd_b.offset = fludd_offset
			fludd_f.offset = fludd_offset

		fludd_b.animation = animation
		fludd_f.animation = animation

		notify_property_list_changed()

@export_storage var doll: AnimatedSprite2D
## Populated in the initialiser only for editor purposes. Not used in-game.
var animation_list: PackedStringArray

@export_storage var fludd_f: AnimatedSprite2D
@export_storage var fludd_b: AnimatedSprite2D
## Populated in the initialiser only for editor purposes. Not used in-game.
var fludd_animation_list: PackedStringArray

## List of offsets connected to frames.
## Used for referencing these values when you need them in regular code.
@export_storage var frame_offsets: Dictionary[int, Vector2i]
## List of FLUDD animations connected to frames.
## Used for referencing these values when you need them in regular code.
@export_storage var frame_fludd: Dictionary[int, String]
## List of FLUDD offsets connected to frames.
## Used for referencing these values when you need them in regular code.
@export_storage var frame_fludd_offsets: Dictionary[int, Vector2i]


func _init() -> void:
	call_deferred(&"setup")


func setup() -> void:
	# We only need to have these references while editing the data resource
	# in the editor. It's no longer relevant when we're running the game.
	if not Engine.is_editor_hint():
		return

	var actor: Player = get_local_scene()

	#if not actor is Player:
		#return

	doll = actor.doll
	fludd_f = actor.fludd_f
	fludd_b = actor.fludd_b

	animation_list = doll.sprite_frames.get_animation_names()

	if fludd_f.sprite_frames.get_animation_names() != fludd_b.sprite_frames.get_animation_names():
		printerr(
		"FLUDD animations don't match! Check the sprite frame resource in both AnimatedSprite2Ds."
		)
	else:
		fludd_animation_list = fludd_f.sprite_frames.get_animation_names()


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
				"hint_string": "rot_y000",
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
