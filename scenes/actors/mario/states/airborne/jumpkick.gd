class_name JumpKick
extends State
# Kicking during a jump (or held jump)


const WALL_KICK_POWER : float = 2.5 # Knockback from kicking against a wall
const KICK_POWER : float = 6


func on_enter():

	actor.vel.y = -KICK_POWER


func physics_tick(_delta):
	actor.movement.move_x("air", false)
	actor.movement.apply_gravity(-actor.vel.y / KICK_POWER)

	if actor.push_ray.is_colliding():
		actor.movement.return_res_prog = actor.movement.RETURN_RES

		actor.vel.x = WALL_KICK_POWER * -actor.movement.facing_direction


func switch_check():
	if actor.vel.y > 0:
		return get_states().fall
