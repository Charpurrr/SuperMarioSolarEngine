@tool
class_name FluddTank
extends Control
## Small utility script that draws the proper visuals for
## the Fludd Tank based on the amount of fuel the player has.

## Temporary max HP export variable for testing,
## realistically this is set within the Player scene.
@export var max_fuel: int = 100:
	set(val):
		max_fuel = clamp(val, 0, INF)
		fuel = clamp(fuel, 0, max_fuel)
@export var fuel: int = max_fuel:
	set(val):
		fuel = clamp(val, 0, max_fuel)

		if is_instance_valid(label):
			label.text = "%d%%" % fuel

		# FuelTop node is last in the scene tree,
		# so checking for it is most reliable.
		if is_instance_valid(fuel_t):
			_update_fuel(fuel)

@export_category("References")
@export var label: Label
@export var container_l: Polygon2D
@export var container_r: Polygon2D
@export var fuel_l: Polygon2D
@export var fuel_r: Polygon2D
@export var fuel_t: Polygon2D

var poly_l_default: PackedVector2Array
var poly_r_default: PackedVector2Array

var container_height: float
var l_p2p_difference: float
var r_p2p_difference: float


func _ready() -> void:
	poly_l_default = container_l.polygon
	poly_r_default = container_r.polygon

	# These operations rely on the size of the panels from the container.

	# Subtracts the Y point in the 3rd quad. [2] by the Y point in the 2nd quad. [1]
	# Basically giving you the length of a vector leading from the top left to the bottom left.
	container_height = poly_l_default[2].y - poly_l_default[1].y
	# Subtracts the Y point in the 2nd quad. [1] by the Y point in the 1st quad. [0]
	# Giving you the difference between the top left and the top right.
	l_p2p_difference = poly_l_default[1].y - poly_l_default[0].y
	r_p2p_difference = poly_r_default[1].y - poly_r_default[0].y


func _update_fuel(new_fuel: float) -> void:
	var y_offset: float = container_height * (1 - (new_fuel / max_fuel))

	fuel_t.visible = new_fuel != 0
	fuel_t.position.y = y_offset

	# 1st quad:[0] | 2nd quad:[1]

	fuel_l.polygon[0].y = y_offset - l_p2p_difference
	fuel_l.polygon[1].y = y_offset

	fuel_r.polygon[0].y = y_offset - r_p2p_difference
	fuel_r.polygon[1].y = y_offset
