class_name SuperDiveRollout
extends DiveRollout
## Action based off of Legacy Super Mario 127's Super Dive Recover speedrun tech.
## Activated by diving and rolling out at the same time.

## The horizontal dive power added to your current velocity.
@export var x_power: float = 6.0
## The maximum horizontal speed you need to reach before dives no longer
## contribute to your x velocity.
@export var speed_cap: float = 8.0



func _on_enter(_param):
	super(_param)

	movement.accelerate(Vector2.RIGHT * movement.facing_direction * x_power, speed_cap)


func _subsequent_ticks():
	super()

	particles[1].emit_at(actor)
