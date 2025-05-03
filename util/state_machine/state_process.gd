class_name StateProcess extends Node

var disabled: bool = false:
	set(value):
		if value:
			process_mode = Node.PROCESS_MODE_DISABLED
		else:
			process_mode = Node.PROCESS_MODE_INHERIT

var state_machine: StateMachine
