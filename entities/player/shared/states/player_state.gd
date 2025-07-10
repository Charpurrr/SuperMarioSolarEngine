class_name PlayerState
extends State
## State specialised for player characters.

@export_enum("Normal", "Small", "Dive", "None") var hitbox_type: String = "Normal"

@export_category(&"Visual")
@export var animation_data: PStateAnimData
## The associated particles that should emit when the state is activated.
@export var particles: Array[ParticleEffect]

@export_category(&"Sound")
## Whether or not the sound effect(s) should play as soon as the state starts.
@export var on_enter: bool = true
## sfx_layers is a list of the possible sound effects that can play at once.
## [br][br]This is useful if you want a state to play more than one sound on entry.
## [br][br]Every array inside of the sfx_layers array is said list of possible
## sound effects it can cycle through.
@export var sfx_layers: Array[SFXLayer]

var input: InputManager = null
var fludd: FluddManager = null
var movement: PMovement = null


func trigger_enter(handover):
	if is_instance_valid(animation_data):
		_set_animation()
		actor.doll.frame_changed.connect(_set_offset)

	_set_hitbox()

	emit_particles()
	play_sounds()

	super(handover)


func trigger_exit():
	super()

	if is_instance_valid(animation_data) and actor.doll.frame_changed.is_connected(_set_offset):
		actor.doll.frame_changed.disconnect(_set_offset)

	for layer in sfx_layers:
		if not layer.cutoff_sfx:
			continue

		for child in get_children():
			if child is AudioStreamPlayer and child.stream in layer.sfx_list:
				child.queue_free()


func play_sounds():
	if on_enter and not sfx_layers.is_empty():
		for sfx_list in sfx_layers:
			sfx_list.play_sfx_at(self)


func emit_particles():
	for effect in particles:
		effect.emit_at(actor)


func _set_hitbox():
	if hitbox_type == "None":
		return

	var was_diving = not actor.dive_hitbox.disabled

	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = true
	actor.dive_hitbox.disabled = true

	match hitbox_type:
		"Normal":
			_snap_dive_to_ground(was_diving)
			actor.hitbox.disabled = false
		"Small":
			_snap_dive_to_ground(was_diving)
			actor.small_hitbox.disabled = false
		"Dive":
			actor.dive_hitbox.disabled = false


## Snap back to the ground if you exit from a dive hitbox to a non-dive hitbox.
func _snap_dive_to_ground(was_diving: bool):
	if was_diving:
		actor.global_position.y -= actor.dive_hitbox.get_shape().get_rect().size.y / 2


func _set_animation():
	if not animation_data.animation.is_empty():
		actor.doll.play(animation_data.animation)


func _set_offset():
	actor.doll.offset = animation_data.frame_offsets.get(actor.doll.frame, Vector2i.ZERO)
