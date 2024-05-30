class_name HomingGroundPoundFall
extends PlayerState
## Falling after performing a homing ground pound.


## How fast you ground pound.
@export var gp_fall_vel: float = 9.0

var closest_obj: Node


func _on_enter(_handover):
	var closest_obj_distance: float = INF

	for obj in actor.homing_radar.get_overlapping_bodies():
		if actor.position.distance_to(obj.position) < closest_obj_distance:
			closest_obj_distance = actor.position.distance_to(obj.position)
			closest_obj = obj


func _physics_tick():
	if not closest_obj == null:
		var distance: Vector2 = closest_obj.position - actor.position
		var remaining_time: float = distance.y / gp_fall_vel
		var speed: float = distance.x / remaining_time

		actor.vel = Vector2(speed, gp_fall_vel)
	else:
		actor.vel.y = gp_fall_vel


func _on_exit():
	closest_obj = null


func _trans_rules():
	if actor.is_on_floor():
		if movement.is_slide_slope():
			return [&"ButtSlide", gp_fall_vel]
		else:
			return &"GroundPoundLand"

	if not movement.dived and movement.can_air_action() and input.buffered_input(&"dive"):
		return [&"FaceplantDive", actor.vel.x]

	if input.buffered_input(&"up"):
		return &"GroundPoundCancel"

	return &""
