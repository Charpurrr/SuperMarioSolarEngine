@tool
class_name Coin
extends Collectible
## Base class for collectible coins.


enum COIN_TYPE{
	YELLOW = 0, ## Common yellow coin, adds +1 to the coin counter.
	BLUE = 1, ## Uncommon blue coin, adds +5 to the coin counter.
	RED = 2, ## One of the level's red coins. Collect all of them to spawn a Shine Sprite.
}

## Total red coin count in a level.
static var total_reds: int = 0

@export var type: COIN_TYPE:
	set(val):
		type = val
		play(str(type))

@export var respective_sounds: Dictionary[COIN_TYPE, AudioStream]
@export var last_red_sound: AudioStream
@export var respective_particles: Dictionary[COIN_TYPE, ParticleEffect]


func _ready() -> void:
	play(str(type))

	if type == COIN_TYPE.RED:
		add_to_group(&"red_coins")
		total_reds += 1

	#GameState.sync_animation(self)


func _on_collect():
	get_tree().emit_signal(&"coin_collected", type)

	var parent: Node = get_parent()

	respective_particles[type].emit_at(parent, position)

	if type == COIN_TYPE.RED:
		var remaining_reds: int = get_tree().get_nodes_in_group(&"red_coins").size()

		if remaining_reds == 1:
			SFX.play_sfx(last_red_sound, &"SFX", parent)
		else:
			var pitch: float = Math.map(remaining_reds, 2, total_reds, 1.5, 1.0)
			SFX.play_sfx(respective_sounds[type], &"SFX", parent, 0.0, pitch)
	else:
		SFX.play_sfx(respective_sounds[type], &"SFX", parent)

	queue_free()
