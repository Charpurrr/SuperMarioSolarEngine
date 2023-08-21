class_name JumpState
extends State
# Jumping state


func physics_tick(_delta):
	actor.vel.y = -actor.movement.JUMP_POWER
