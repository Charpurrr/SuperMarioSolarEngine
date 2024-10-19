class_name PropertyDisplayData
extends Resource
## Stores data about a [PropertyDisplay], and provides methods for adding it to a preview display.

## Creates the [PropertyDisplay] and adds it as a child of the target.
## Returns the [PropertyDisplay] node that was created.
## Should be overridden by child classes.
func add_to(_target: Node) -> PropertyDisplay:
	assert(false, "PropertyDisplayData is an abstract class, and must be inherited by a child class.")
	return null
