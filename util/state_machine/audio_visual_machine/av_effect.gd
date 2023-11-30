class_name AVEffect
extends Node
## An audiovisual effect, triggered by the AVManager.


## The target this effect should apply to.
@export var target: Node

## Only fire this effect once.
@export var one_shot: bool = false
## If the effect should deactivate after being replaced.
@export var deactivate_on_switch: bool = false

var active: bool = false


func _physics_process(_delta):
	if active:
		do_effect()


## Trigger the effect with the given name.
func trigger() -> void:
	if not one_shot:
		active = true
	else:
		do_effect()
		sub_effects()


## Behavior of the effect.
func do_effect() -> void:
	pass


## Deactivates the effect.
func deactivate():
	active = false


## Trigger sub-effects.
## If "" is received as input, trigger all sub-effects.
## Otherwise, trigger only the effect named by the argument.
func sub_effects() -> void:
	for child in get_children():
		child.trigger()
