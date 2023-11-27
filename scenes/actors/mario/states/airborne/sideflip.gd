class_name Sideflip
extends PlayerState
## Jumping after turning.


const PUSH_POWER: float = 1.2
const JUMP_POWER: float = 8.8


func _on_enter(_handover):
	movement.update_direction(sign(movement.get_input_x()))
	actor.vel.y = -JUMP_POWER


func _post_tick():
	movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func _cycle_tick():
	if actor.vel.y < -JUMP_POWER + 1:
		actor.vel.x = PUSH_POWER * input_direction

	movement.move_x(0.1, false)


func _tell_switch():
	if actor.is_on_ceiling():
		return &"Fall"

	if movement.can_wallslide():
		return &"Wallslide"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	return &""
