class_name DamageManager extends Node

@export var actor : Player
@export var hurtbox : Area2D
@export var general_damage_sounds : SFXLayer

func damage_player(hitbox: Hitbox, damage: DamageComponent):
	get_tree().emit_signal(&"player_damaged", damage.amount)
	animate_damage(damage.type)
	DamageComponent.deal_knockback(actor, hitbox, damage)

func animate_damage(damage_type: DamageComponent.DAMAGE_TYPE):
	match damage_type:
		#region TODO
		DamageComponent.DAMAGE_TYPE.STRIKE: pass
		DamageComponent.DAMAGE_TYPE.SQUISH: pass
		DamageComponent.DAMAGE_TYPE.EXPLOSION: pass
		#endregion
		_: # TODO This should be done with the state machine but i have no idea how that works
			actor.doll.play(&"bonk")
			general_damage_sounds.play_sfx_at(self)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var damage : DamageComponent = area.damage_component
	
	if Hitbox.can_harm_player(area):
		damage_player(area, damage)
