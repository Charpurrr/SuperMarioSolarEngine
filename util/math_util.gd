class_name Math
## Provides useful math functions that you can call using [code]Math.function_name[/code].


## Round a value to a specific decimal place.
static func roundp(value: float, decimal: int) -> float:
	return round(value * pow(10, decimal)) / pow(10, decimal)


## If input is positive, returns 1. If input is negative or zero, returns 0.
static func sign_positive(input: Variant) -> Variant:
	return max(sign(input), 0)
