class_name AirSpin
extends PlayerState
## Spinning for the first time while airborne.


## Knockback from spinning against a wall
const WALL_KICKBACK_POWER: float = 2.5
const SPIN_POWER: float = 6


func _on_enter(_handover):
	movement.consume_coyote_timer()

	actor.vel.y = -SPIN_POWER


func _post_tick():
	movement.apply_gravity(-actor.vel.y / SPIN_POWER)


func _cycle_tick():
	movement.move_x("air", false)

	if actor.push_ray.is_colliding():
		movement.return_res_prog = movement.RETURN_RES

		actor.vel.x = WALL_KICKBACK_POWER * -movement.facing_direction


func _tell_switch():
	return &""
