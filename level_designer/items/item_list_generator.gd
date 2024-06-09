@tool
extends Node


@export var refresh_item_list: bool :
	set(_value):
		_refresh_list()
	get:
		return false

const ITEM_LIST_PATH = "res://level_designer/items/editor_items/editor_item_list.tres"


func _refresh_list():
	var filesystem = EditorInterface.get_resource_filesystem()
	var item_list := EditorItemList.new()

	_explore_directory(filesystem.get_filesystem(), item_list)


	ResourceSaver.save(item_list, ITEM_LIST_PATH, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS & ResourceSaver.FLAG_CHANGE_PATH)

	filesystem.reimport_files([ITEM_LIST_PATH])

	print("Refreshed the EditorItemList! The engine threw an error, but this isn't actually a problem.")


func _explore_directory(dir: EditorFileSystemDirectory, item_list: EditorItemList):
	for i in dir.get_subdir_count():
		_explore_directory(dir.get_subdir(i), item_list)

	for i in dir.get_file_count():
		var file = dir.get_file_path(i)

		if file.ends_with(".tres"):
			var resource = load(file)

			if resource is EditorItem:
				item_list.items.append(resource)
