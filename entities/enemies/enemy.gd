class_name Enemy
extends CharacterBody2D
## Abstract class for all enemies.

@export var hp: int

@export_category(&"References")
@export var collision: CollisionShape2D
@export var anime: AnimationPlayer
@export var doll: AnimatedSprite2D

@onready var health_module := HealthModule.new(hp, take_hit, die)

## Current velocity.
var vel := Vector2.ZERO


func _ready():
	set_up_direction(Vector2.UP)


func _physics_process(delta):
	set_velocity(vel / delta)
	move_and_slide()

	vel = velocity * delta


## Behaviour for getting hit. (Gets overridden by child class.)
func take_hit(_source: Node, _damage_type: HealthModule.DamageType):
	pass


## Behaviour for dying. (Gets overridden by child class.)
func die(_source: Node, _damage_type: HealthModule.DamageType):
	pass
