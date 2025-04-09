class_name Goomba extends Enemy

var target: Player

func _physics_process(delta: float) -> void:
	vel.y += .3
	super(delta)
