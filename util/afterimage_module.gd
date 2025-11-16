class_name AfterimageModule
extends Node

@export var enabled: bool = false:
	set(val):
		enabled = val

		if val == true:
			afterimage_timer = afterimage_cooldown

@export var actor: Node2D

@export_group("Afterimage", "afterimage")
@export var afterimage_color: Color
## How fast the afterimage effect displays (in frames.)
@export var afterimage_cooldown: int = 5
var afterimage_timer: int

@export var afterimage_offset: Vector2
@export var afterimage_particle: ParticleEffect


func _process(_delta: float) -> void:
	if not enabled:
		return

	afterimage_timer = max(afterimage_timer - 1, 0)

	if afterimage_timer == 0:
		afterimage_timer = afterimage_cooldown

		var afterimage = afterimage_particle.emit_at(actor, afterimage_offset)
		afterimage.doll = actor.doll
		afterimage.trail_color = afterimage_color
