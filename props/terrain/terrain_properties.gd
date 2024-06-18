class_name TerrainProperties
extends Resource
## Data for terrain and how the player interacts with it.

@export var type: TerrainType
## Whether or not the player can pass through this terrain when equipped with the vanish cap.
@export var vanish_passable: bool

enum TerrainType {
	GRASS,
	GLASS,
	ROCK,
	SAND,
	SNOW,
}
