## Base class for all enemies.
class_name Enemy extends Actor

@export var hp: int

@export_group(&"State Handling")
## The state machine responsible for handling the enemy's states
@export var state_machine: StateMachine
## Where animations (states) will be defined for the enemy.
@export var animation_player: AnimationPlayer
## If [member hitbox] is defined, this dictionary will serve as the response to different
## damage types. Each item in the dictionary corresponds to a respective state in the 
## [member state_machine], definied by the StringName.
@export var damage_responses: Dictionary[DamageComponent.DamageType, StringName]
@export_group(&"References")
@export var hitbox: Hitbox
@export var doll: AnimatedSprite2D


## Current velocity.
var vel := Vector2.ZERO

func _ready():
	set_up_direction(Vector2.UP)
	hitbox.damage_collision.connect(_damage_behavior)
	state_machine.machine_ended.connect(_die_behavior)

func _physics_process(delta):
	set_velocity(vel / delta)
	move_and_slide()

	vel = velocity * delta

## Behaviour for getting hit. (Can be overridden by child class.)
func _damage_behavior(damage: DamageComponent, sender: Hitbox) -> void:
	hp -= damage.amount
		
	if state_machine:
		state_machine.set_state(damage_responses.get(damage.type))
	
	if damage.knockback:
		_knockback_behavior(damage, sender)

## Knockback behavior (can be overrided)
func _knockback_behavior(damage: DamageComponent, sender: Hitbox):
	DamageComponent.deal_knockback(self, sender.owner, damage)

## Behaviour for dying. (Can be overridden by child class.)
func _die_behavior():
	queue_free()
