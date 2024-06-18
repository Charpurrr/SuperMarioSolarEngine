class_name SimplePropertyDisplayData
extends PropertyDisplayData
## TODO: doc

@export var root_script: Script


func add_to(node: Node):
	var inst = root_script.new()
	node.add_child(inst)
