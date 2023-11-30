class_name GroundSpin
extends PlayerState
## Spinning for the first time while grounded.




# bugfix: groundspin buffer gets overwritten by other states, use tell defer





## Knockback from spinning against a wall
const WALL_KICKBACK_POWER: float = 2.5


func _on_enter(_handover):
	movement.consume_coyote_timer()


func _cycle_tick():
	movement.move_x("ground", false)

	if actor.push_ray.is_colliding():
		movement.return_res_prog = movement.RETURN_RES

		actor.vel.x = WALL_KICKBACK_POWER * -movement.facing_direction


func _tell_switch():
	return &""
