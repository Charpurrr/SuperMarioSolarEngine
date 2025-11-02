class_name Goomba
extends Enemy
## Goomba behaviour.

@export var gravity: float = 1

@export var strike_x_power: float = 2
@export var strike_y_power: float = 4

## Whether or not the Goomba should die when ready.
var ready_to_perish: bool = false:
	set(val):
		ready_to_perish = val

		if val == true:
			queue_free()

var death_type: HealthModule.DamageType


func _physics_process(delta):
	vel.y += gravity

	# Special death requirements
	if death_type == HealthModule.DamageType.STRIKE:
		ready_to_perish = is_on_floor() and vel.y >= 0

	super(delta)


func take_hit(_source: Node, _damage_type: HealthModule.DamageType):
	pass


func die(source: Node, damage_type: HealthModule.DamageType):
	death_type = damage_type

	match damage_type:
		HealthModule.DamageType.STRIKE:
			vel.x = source.vel.x - sign(source.position.x - position.x) * strike_x_power
			vel.y = -strike_y_power
			anime.play(&"die_strike")

		HealthModule.DamageType.SQUISH:
			anime.play(&"die_squish")
			anime.animation_finished.connect(func(_anim_name: StringName): ready_to_perish = true)
