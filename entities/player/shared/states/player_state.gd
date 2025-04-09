class_name PlayerState
extends State
## State specialised for player characters.

@export_enum("Normal", "Small", "Dive", "None") var collision_type: String = "Normal"

@export_category(&"Animation")
## The name of the animation that this state should play.
@export var animation := &""
## How many pixels the animation needs to be offset.
@export var anim_offset: Vector2i

@export_category(&"Sound")
## Whether or not the sound effect(s) should play as soon as the state starts.
@export var on_enter: bool = true
## sfx_layers is a list of the possible sound effects that can play at once.
## [br][br]This is useful if you want a state to play more than one sound on entry.
## [br][br]Every array inside of the sfx_layers array is said list of possible
## sound effects it can cycle through.
@export var sfx_layers: Array[SFXLayer]

## The associated particles that should emit when the state is activated.
@export var particles: Array[ParticleEffect]

var input: InputManager = null
var fludd: FluddManager = null
var movement: PMovement = null


func trigger_enter(handover):
	_set_animation()
	_play_sounds()
	_emit_particles()
	_set_collision()

	super(handover)


func _set_collision():
	if collision_type == "None":
		return

	var was_diving = not actor.dive_collision.disabled

	actor.collision.disabled = true
	actor.small_collision.disabled = true
	actor.dive_collision.disabled = true

	match collision_type:
		"Normal":
			_snap_dive_to_ground(was_diving)
			actor.collision.disabled = false
		"Small":
			_snap_dive_to_ground(was_diving)
			actor.small_collision.disabled = false
		"Dive":
			actor.dive_collision.disabled = false


## Snap back to the ground if you exit from a dive collision box to a non-dive collision box.
func _snap_dive_to_ground(was_diving: bool):
	if was_diving:
		actor.global_position.y -= actor.dive_collision.get_shape().get_rect().size.y / 2


func _set_animation():
	if not animation.is_empty():
		actor.doll.play(animation)

	actor.doll.offset = anim_offset


func _play_sounds():
	if on_enter and not sfx_layers.is_empty():
		for sfx_list in sfx_layers:
			sfx_list.play_sfx_at(self)


func _emit_particles():
	for effect in particles:
		effect.emit_at(actor)


func trigger_exit():
	super()

	for layer in sfx_layers:
		if not layer.cutoff_sfx:
			continue

		for child in get_children():
			if child is AudioStreamPlayer and child.stream in layer.sfx_list:
				child.queue_free()
