class_name Math
## Provides useful math functions that you can call using [code]Math.function_name[/code].


## Round a value to a specific decimal place.
static func roundp(value: float, decimal: int) -> float:
	return round(value * pow(10, decimal)) / pow(10, decimal)


## If input is positive, returns 1. If input is negative or zero, returns 0.
static func sign_positive(input: Variant) -> Variant:
	return max(sign(input), 0)


### Returns the closest point on a line in relation to the reference point.
#static func get_closest_point_line(
		#start_line: Vector2,
		#end_line: Vector2,
		#ref_point: Vector2
	#) -> Vector2:
#
	#var s_to_r := Vector2(ref_point.x - start_line.x, ref_point.y - start_line.y)
	#var s_to_e := Vector2(end_line.x - start_line.x, end_line.y - start_line.y)
#
	## Squared magnitude of the line.
	#var sqr_magnitude: float = pow(s_to_e.x, 2) + pow(s_to_e.y, 2)
#
	## The normalized "distance" from the start of the line to the reference point.
	#var t = s_to_r.dot(s_to_e) / sqr_magnitude
#
	## Add the distance to the starting point, moving towards the ending point.
	#return Vector2(start_line.x + s_to_e.x * t, start_line.y + s_to_e.y * t)
