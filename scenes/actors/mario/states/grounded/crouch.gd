class_name Crouch
extends State
# Holding down on the floor


func physics_tick(_delta):
	var direction = int(Input.is_action_just_released("right")) - int(Input.is_action_just_released("left"))

	actor.movement.update_direction(direction)
	actor.movement.decelerate("ground")


func switch_check():
	if not Input.is_action_pressed("down") and actor.vel.x == 0:
		return get_states().idle

	if Input.is_action_just_pressed("jump"):
		return %Backflip
