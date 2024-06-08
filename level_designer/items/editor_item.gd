class_name EditorItem
extends Resource
## Data for an item placed inside of the Level Editor.


@export var item_scene: PackedScene
@export var icon_texture: Texture2D

@export var category: Category

enum Category {
	TERRAIN, 
	OBJECT, 
	DECORATION,
	ENTITY,
	NPC,
	UTILITY,
}
