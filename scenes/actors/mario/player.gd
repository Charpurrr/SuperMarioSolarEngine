class_name Player
extends CharacterBody2D
# Playable 2D character


@onready var doll : AnimatedSprite2D = $Doll
@onready var movement : Object = $Movement

@onready var push_ray : RayCast2D = $PushRay

@onready var crouchbox : CollisionShape2D = %Crouchbox
@onready var hitbox : CollisionShape2D = %Hitbox
@onready var crouch_lock : Area2D = %CrouchLock

var vel : Vector2 # Current velocity


func _ready():
	set_up_direction(Vector2.UP)


func _physics_process(delta):
	set_velocity(vel / delta)
	move_and_slide()
	vel = velocity * delta
