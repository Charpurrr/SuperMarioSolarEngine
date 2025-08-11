class_name Hover
extends PlayerState
## Using the Hover nozzle.


func _physics_tick():
	if not actor.movement.is_submerged():
		_dry_logic()
	else:
		_submerged_logic()


## While underwater.
func _submerged_logic():
	pass


## While outside of water.
func _dry_logic():
	pass
