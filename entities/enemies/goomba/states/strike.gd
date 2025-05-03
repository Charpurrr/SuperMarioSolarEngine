extends State

func _physics_process(_delta: float) -> void:
	if owner.is_on_floor():
		owner.vel.x = 0
		state_machine.set_state(&"idle")

func _on_exit():
	owner.hitbox.disabled = false
