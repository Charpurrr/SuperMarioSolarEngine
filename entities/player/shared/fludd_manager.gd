class_name FluddManager
extends Node
## Handles communication between PlayerStates in regards to FLUDD.

## FLUDD sprites that show behind the player.
@export var fludd_b: AnimatedSprite2D
## FLUDD sprites that show infront of the player.
@export var fludd_f: AnimatedSprite2D

enum Nozzle{
	NONE,
	HOVER,
	ROCKET,
	TURBO,
}

var available_nozzles: Array[Nozzle] = [
	Nozzle.NONE,
	Nozzle.HOVER,
	#Nozzle.ROCKET,
	#Nozzle.TURBO,
	]

static var active_nozzle: Nozzle = Nozzle.NONE


func switch_nozzle() -> void:
	var current_id: int = available_nozzles.find(active_nozzle)

	active_nozzle = available_nozzles[wrapi(current_id + 1, 0, available_nozzles.size())]

	fludd_b.visible = active_nozzle != Nozzle.NONE
	fludd_f.visible = active_nozzle != Nozzle.NONE

	print(Nozzle.find_key(active_nozzle))


func _physics_process(_delta: float) -> void:
	# Done within physics process to guarantee being properly synced with the player.
	if Input.is_action_just_pressed(&"switch_nozzle"):
		switch_nozzle()
