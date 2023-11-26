class_name Sideflip
extends PlayerState
## Jumping after turning.


const PUSH_POWER: float = 1.2
const JUMP_POWER: float = 8.8


func _on_enter(_handover):
	actor.vel.y = -JUMP_POWER
	actor.animplay.play("sideflip")


func _on_exit():
	actor.animplay.stop()


func _cycle_tick():
	if actor.vel.y < -JUMP_POWER + 1:
		actor.vel.x = PUSH_POWER * input_direction

	actor.movement.move_x(0.1, true)


func _post_tick():
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func switch_check():
	if actor.is_on_ceiling():
		return &"Fall"

	if actor.movement.can_wallslide():
		return &"Wallslide"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"
