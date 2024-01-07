class_name Player
extends CharacterBody2D
## Playable 2D character.


@onready var animplay: AnimationPlayer = %AnimationPlayer
@onready var doll: AnimatedSprite2D = $Doll

@onready var movement: Object = $Movement
@onready var input: Object = $InputManager

@onready var push_rays: Node = $PushRays
 
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var dive_hitbox: CollisionShape2D = $DiveHitbox
@onready var small_hitbox: CollisionShape2D = $SmallHitbox

## Current velocity.
var vel: Vector2


func _ready():
	set_up_direction(Vector2.UP)


func _physics_process(delta):
	set_velocity(vel / delta)
	move_and_slide()

	print(movement.air_spun)

	floor_constant_speed = movement.is_steep_slope()

	vel = velocity * delta
