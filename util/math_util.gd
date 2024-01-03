class_name Math
extends Object


## Round a value to a specific decimal place.
static func roundp(value: float, decimal: int) -> float:
	return round(value * pow(10, decimal)) / pow(10, decimal)
