extends CPUParticles2D

@export var doll: AnimatedSprite2D:
	set(val):
		texture = val.sprite_frames.get_frame_texture(val.animation, val.frame)

@export var trail_color: Color
