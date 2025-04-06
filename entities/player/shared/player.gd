class_name Player
extends CharacterBody2D
## Playable 2D character.

@export var doll: AnimatedSprite2D

@export_group("Managers")
@export var state_manager: StateManager
@export var movement: PMovement
@export var input: InputManager
@export var damage_manager: DamageManager

@export_group("Collision")
@export var push_rays: Node2D
@export var hitbox: CollisionShape2D
@export var dive_hitbox: CollisionShape2D
@export var small_hitbox: CollisionShape2D
@export var water_check: Area2D
@export var crouchlock: CrouchlockDetection

@export_group("Hitboxes")
@export var spin_hitbox: Hitbox
@export var foot_hitbox: Hitbox

## Current velocity.
var vel := Vector2.ZERO

func _ready():
	set_up_direction(Vector2.UP)


func _physics_process(delta):
	set_velocity(vel / delta)
	move_and_slide()

	vel = velocity * delta
