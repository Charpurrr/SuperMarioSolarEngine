class_name JumpKick
extends PlayerState
## Kicking during a jump (or held jump)


## Knockback from kicking against a wall
const WALL_KICK_POWER: float = 2.5
const KICK_POWER: float = 6


func _on_enter(_handover):
	actor.vel.y = -KICK_POWER


func _post_tick():
	movement.apply_gravity(-actor.vel.y / KICK_POWER)


func _cycle_tick():
	movement.move_x("air", false)

	if actor.push_ray.is_colliding():
		movement.return_res_prog = movement.RETURN_RES

		actor.vel.x = WALL_KICK_POWER * -movement.facing_direction


func _tell_switch():
	if actor.vel.y > 0:
		return &"Fall"

	return &""
