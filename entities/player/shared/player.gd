class_name Player
extends CharacterBody2D
## Playable 2D character.

@export var doll: AnimatedSprite2D

@export_group("Managers")
@export var state_manager: pStateManager
@export var movement: PMovement
@export var input: InputManager
@export var fludd_manager: FluddManager

@export_group("Collision")
@export var collision: CollisionShape2D
@export var small_collision: CollisionShape2D
@export var dive_collision: CollisionShape2D
@export var push_rays: Node2D

@export_group("Hitboxes")
@export var hurtbox: Hitbox
@export var foot_hitbox: Hitbox
@export var spin_hitbox: Hitbox

@export_group("Areas")
@export var water_check: Area2D
@export var crouchlock: CrouchlockDetection


## Current velocity.
var vel := Vector2.ZERO


func _ready():
	set_up_direction(Vector2.UP)


func _physics_process(delta):
	set_velocity(vel / delta)
	move_and_slide()

	vel = velocity * delta
