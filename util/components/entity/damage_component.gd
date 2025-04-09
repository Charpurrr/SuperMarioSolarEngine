@tool
class_name DamageComponent extends Component

enum DamageType {
	## General damage
	GENERAL,
	## Caused by the player's spin attack
	STRIKE,
	## Caused by either being crushed or jumped on by the player
	SQUISH,
	## Caused by fire and lava
	BURN,
	## Caused by exploding bob-ombs.
	EXPLOSION,
	##
	FREEZE,
	##
	SHOCK,
}

## The amount of damage to deal
@export_range(0, 1000) var amount: int = 1
## The type of damage to inflict (primarily affects animations)
@export var type: DamageType
## The amount of knockback to deal (works in the negative direction of the entity's velocity)
@export var knockback: bool = true:
	set(value):
		notify_property_list_changed()
		knockback = value

var knockback_amount: Vector2 = Vector2(4.0, 3.0)
## Adds the knockback to the entity's current velocity
var additive_knockback: bool = false

static func deal_knockback(actor: CharacterBody2D, source: Node2D, damage: DamageComponent):
	var direction: Vector2 = (actor.global_position - source.global_position).normalized()
	var x_sign: int = sign(direction.x)
	if x_sign == 0:
		x_sign = 1 # fallback to the positive direction if 0 is returned

	if damage.additive_knockback:
		actor.vel.x += damage.knockback_amount.x * x_sign
		actor.vel.y -= damage.knockback_amount.y * -1.0
	else:
		actor.vel.x = damage.knockback_amount.x * x_sign
		actor.vel.y = damage.knockback_amount.y * -1.0

# This function is responsible for updating the property list if "knockback" is togged.
func _get_property_list() -> Array:
	var properties = []
	if knockback:
		properties.append({
			"name": "Knockback Settings",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP
		})
		properties.append({
			"name": "knockback_amount",
			"type": TYPE_VECTOR2,
			"usage": PROPERTY_USAGE_DEFAULT
		})
		properties.append({
			"name": "additive_knockback",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT
		})
	return properties
