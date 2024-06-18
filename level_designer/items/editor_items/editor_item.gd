class_name EditorItem
extends Resource
## Data for an item inside of the Level Editor.

const PREVIEW_ITEM: PackedScene = preload(
	"res://level_designer/items/preview_items/preview_item.tscn"
)

## Icon texture that represents this item.
@export var icon_texture: Texture2D

## Search category that this item is in.
@export var category: Category

## List of item properties that this item has.
@export var properties: Array[Property]

## PreviewDisplayData associated with this item.
@export var preview_display_data: PreviewDisplayData

enum Category {
	TERRAIN,
	OBJECT,
	DECORATION,
	ENTITY,
	NPC,
	UTILITY,
}


func create_preview() -> PreviewItem:
	var inst = PREVIEW_ITEM.instantiate()
	inst.create(self)
	return inst


func get_selection_hull() -> Shape2D:
	return null
