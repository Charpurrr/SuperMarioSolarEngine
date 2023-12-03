class_name DiveRay
extends RayCast2D
# A ray to check for the angle of the ground below.


## Returns the angle of the floor below the player.
func get_floor_angle():
	return get_collision_normal().angle()
