class_name FallState
extends State
# Falling state


func physics_tick(_delta):
	actor.vel.y += actor.movement.GRAVITY
	actor.vel.y = min(actor.vel.y, actor.movement.TERM_VEL)
