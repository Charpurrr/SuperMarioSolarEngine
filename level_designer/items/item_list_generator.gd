@tool
extends ResourceGenerator


const ITEM_LIST_PATH = "res://level_designer/items/editor_items/editor_item_list.tres"


func _process_all(filesystem, resource_list):
	var item_list := EditorItemList.new()
	item_list.items.append_array(resource_list)
	const FLAGS = ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS & ResourceSaver.FLAG_CHANGE_PATH
	ResourceSaver.save(item_list, ITEM_LIST_PATH, FLAGS)

	filesystem.reimport_files([ITEM_LIST_PATH])


func _is_correct_type(resource: Resource) -> bool:
	return resource is EditorItem
