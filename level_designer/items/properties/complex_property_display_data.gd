class_name ComplexPropertyDisplayData
extends PropertyDisplayData
## TODO: doc

@export var scene: PackedScene

func add_to(node: Node):
	var inst = scene.instantiate()
	node.add_child(inst)
