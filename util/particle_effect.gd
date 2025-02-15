class_name ParticleEffect
extends Resource

## Associated scene of this particle effect.
@export var particle_scene: PackedScene
## Whether or not the particle only emits once.
@export var oneshot: bool = true
## When emitting continously, how much time is between emits in seconds.
@export var emit_delay: float = 0.0


## Emit the particle one time at a specific node.
func emit_once_at(node: Node):
	var particle: CPUParticles2D = particle_scene.instantiate()

	node.add_child(particle)
	particle.emitting = true

	particle.connect(&"finished", particle.queue_free)


func emit_continous_at(node: Node):
	var particle: CPUParticles2D = particle_scene.instantiate()

	node.add_child(particle)
	particle.emitting = true

	particle.connect(&"finished", particle.queue_free)
