class_name ItemSearchMenu
extends Panel
## Search menu for all editor items.


@export var item_list: EditorItemList
@export var item_slot: PackedScene

@export var catg_terrain: HFlowContainer
@export var catg_object: HFlowContainer
@export var catg_decoration: HFlowContainer
@export var catg_entity: HFlowContainer
@export var catg_npc: HFlowContainer
@export var catg_utility: HFlowContainer

@onready var category_connections: Dictionary = {
	EditorItem.Category.TERRAIN: catg_terrain,
	EditorItem.Category.OBJECT: catg_object,
	EditorItem.Category.DECORATION: catg_decoration,
	EditorItem.Category.ENTITY: catg_entity,
	EditorItem.Category.NPC: catg_npc,
	EditorItem.Category.UTILITY: catg_utility,
}


func _ready():
	for item in item_list.item_list:
		var inst: Node = item_slot.instantiate()

		category_connections[item.category].add_child(inst)
		inst.create_item(item)
