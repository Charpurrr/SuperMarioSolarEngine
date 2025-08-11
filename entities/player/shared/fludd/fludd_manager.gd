class_name FluddManager
extends Node
## Handles communication between PlayerStates in regards to FLUDD.

@export var hover_power: float
@export var hover_accel: float
@export var rocket_power: float
@export var turbo_power: float

@export_category("References")
@export var actor: Player

## FLUDD sprites that show behind the player.
@export var fludd_b: AnimatedSprite2D
## FLUDD sprites that show infront of the player.
@export var fludd_f: AnimatedSprite2D

@export_category("Audio")
@export var toggle_sfx: AudioStream
@export var switch_sfx: AudioStream

enum Nozzle{
	NONE,
	HOVER,
	ROCKET,
	TURBO,
}

var available_nozzles: Array[Nozzle] = [
	Nozzle.NONE,
	Nozzle.HOVER,
	#Nozzle.ROCKET,
	#Nozzle.TURBO,
	]

## Which nozzle the player is currently using.
static var active_nozzle: Nozzle = Nozzle.NONE
## How much water is left in the FLUDD tank. (in percent)
static var fuel: int = 100


## The base behaviour of the hover nozzle.
## Boosts you in the direction of the player's body rotation.
func hover():
	var rot_vec := Vector2.UP.rotated(actor.movement.body_rotation)
	var boost_vec: Vector2 = rot_vec * -hover_power
	print(rot_vec, boost_vec)

	if abs(actor.vel.x) < abs(boost_vec.x):
		actor.vel.x += hover_accel * rot_vec.x

	if (sign(rot_vec.y) * (actor.vel.y + boost_vec.y) < 0):
		actor.vel.y += hover_accel * rot_vec.y


func switch_nozzle() -> void:
	var current_id: int = available_nozzles.find(active_nozzle)

	active_nozzle = available_nozzles[wrapi(current_id + 1, 0, available_nozzles.size())]

	get_tree().call_group("%s/sfx" % name, &"queue_free")

	if active_nozzle != Nozzle.NONE:
		SFX.play_sfx(switch_sfx, &"SFX", self)
		fludd_b.visible = true
		fludd_f.visible = true
	else:
		SFX.play_sfx(toggle_sfx, &"SFX", self)
		fludd_b.visible = false
		fludd_f.visible = false

	print(Nozzle.find_key(active_nozzle))


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(&"switch_nozzle"):
		switch_nozzle()


func _ready() -> void:
	active_nozzle = Nozzle.NONE


# Syncs up FLUDD's rotation with the player's sprite rotation.
func _process(_delta: float) -> void:
	fludd_b.rotation = actor.doll.rotation
	fludd_f.rotation = actor.doll.rotation

	# Called here instead of _input() to avoid ignorance when holding the action key.
	if Input.is_action_pressed(&"use_fludd"):
		match active_nozzle:
			Nozzle.HOVER:
				hover()
