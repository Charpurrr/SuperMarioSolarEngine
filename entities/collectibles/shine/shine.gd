class_name Shine
extends Collectible
## Collectible Shine Sprites.

@export var shine_name: StringName
@export_multiline var description: String

@export var particle: ParticleEffect


func _process(_delta: float) -> void:
	pass
	#particle.emit_at(self)


func _on_collect() -> void:
	super()
	#player.state_manager.switch_substate(&"Fall")
