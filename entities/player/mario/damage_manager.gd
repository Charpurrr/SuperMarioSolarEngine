## TODO This class is temporary whilst we still figure out how the player Statemachine should be approached.
class_name DamageManager extends Node

@export var actor : Player
@export var general_damage_sounds : SFXLayer

func animate_damage(damage_type: DamageComponent.DamageType):
	match damage_type:
		DamageComponent.DamageType.STRIKE:
			actor.doll.play(&"bonk")
			general_damage_sounds.play_sfx_at(self)

func _on_damage(damage: DamageComponent, sender: Area2D) -> void:
	get_tree().emit_signal(&"player_damaged", damage.amount)
	animate_damage(damage.type)
	DamageComponent.deal_knockback(actor, sender, damage)
