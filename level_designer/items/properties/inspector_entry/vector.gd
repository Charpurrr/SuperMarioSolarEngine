extends InspectorEntry

@export var component_list: VBoxContainer
@export var component_scene: PackedScene
@export var components: Array[String] = ["x", "y"]


func _ready():
	create_components(components)


func create_components(component_labels: Array[String]) -> void:
	var first: bool = true
	for child in component_list.get_children():
		child.queue_free()
	for component_label in component_labels:
		var inst = component_scene.instantiate()
		inst.set_label(component_label)
		inst.value_changed.connect(_update_vector.unbind(1))
		component_list.add_child(inst)
		if first:
			label.custom_minimum_size.y = inst.size.y
			first = false


func set_value(value: Variant) -> void:
	var num
	for i in components.size():
		component_list.get_child(i).set_value(value[i])


func _update_vector() -> void:
	value_changed.emit(_get_vector())


func _get_vector():
	match components.size():
		2:
			return Vector2(_get_component_value(0), _get_component_value(1))
		3:
			return Vector3(_get_component_value(0), _get_component_value(1), _get_component_value(2))
		4:
			return Vector4(_get_component_value(0), _get_component_value(1), _get_component_value(2), _get_component_value(3))
		_:
			assert(false, "No support for vectors of size %d." % components.size())


func _get_component_value(idx: int) -> float:
	var component = component_list.get_child(idx)
	return component.get_value()
