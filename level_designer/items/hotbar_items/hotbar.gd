class_name Hotbar
extends HFlowContainer
## The level designer hotbar.


var pinned_items: Array = []

@export var editor: LevelEditor


func add_item(item_data: EditorItem):
	var last_slot: HotbarItem = null
	var slots: Array[Node] = get_children()

	slots.reverse()

	var skipped_pins: Array = []

	for slot in slots:
		if slot in pinned_items:
			skipped_pins.append(slot)
		else:
			last_slot = slot
			break

	if last_slot == null:
		return

	last_slot.create_data(item_data)

	move_child(last_slot, 0)

	for item in get_children():
		if item in pinned_items and item not in skipped_pins:
			move_child(item, item.get_index() - 1)


func pin_item(item: HotbarItem):
	pinned_items.append(item)


func unpin_item(item: HotbarItem):
	pinned_items.erase(item)
