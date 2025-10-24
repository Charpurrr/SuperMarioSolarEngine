class_name Goomba
extends Enemy
## Goomba behaviour.

@export var gravity: float = 1

@export var strike_x_power: float = 2
@export var strike_y_power: float = 4

## Whether or not the Goomba should die when ready.
var ready_to_perish: bool = false


func _physics_process(delta):
	vel.y += gravity

	# Die
	if is_on_floor() and vel.y >= 0 and ready_to_perish:
		vel.y = min(vel.y, 0)
		queue_free()

	super(delta)


func take_hit(_source: Node, _damage_type: HealthModule.DamageType):
	pass


func die(source: Node, damage_type: HealthModule.DamageType):
	match damage_type:
		HealthModule.DamageType.STRIKE:
			vel.x = source.vel.x - sign(source.position.x - position.x) * strike_x_power
			vel.y = -strike_y_power

			ready_to_perish = true
			anime.play(&"die_strike")

		HealthModule.DamageType.SQUISH:
			pass
