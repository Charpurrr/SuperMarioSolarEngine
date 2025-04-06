class_name DamageComponent extends Resource

enum DAMAGE_TYPE {
	GENERAL,
	STRIKE,
	SQUISH,
	BURN,
	EXPLOSION,
	FREEZE,
	SHOCK,
}

## The amount of damage to deal
@export_range(0, 1000) var amount: int

## The amount of knockback to deal (works in the negative direction of the entity's velocity)
@export var knockback: Vector2 = Vector2(4.5, 3.5)

## Adds the knockback to the entity's current velocity
@export var additive_knockback: bool = false

## Whether damage is enabled for this hitbox
@export var disabled: bool = false

## The type of damage to inflict (primarily affects animations)
@export var type: DAMAGE_TYPE

static func deal_knockback(actor: CharacterBody2D, source: Node2D, damage: DamageComponent):
	if damage.disabled:
		return
		
	var direction: Vector2 = (actor.global_position - source.global_position).normalized()
	var x_sign: int = sign(direction.x)
	if x_sign == 0:
		x_sign = 1 # fallback to the positive direction if 0 is returned

	if damage.additive_knockback:
		actor.vel.x += damage.knockback.x * x_sign
		actor.vel.y -= damage.knockback.y * -1.0
	else:
		actor.vel.x = damage.knockback.x * x_sign
		actor.vel.y = damage.knockback.y * -1.0
