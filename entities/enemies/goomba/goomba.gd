class_name Goomba
extends Enemy
## Goomba behaviour.

@export var gravity: float = 1

## Whether or not the Goomba should die when ready.
var ready_to_perish: bool = false

func _ready() -> void:
	anime.animation_finished.connect(check_health)

func _take_hit(damage_hitbox: Hitbox):
	var damage : DamageComponent = damage_hitbox.damage_component
	if !damage: return
	
	# Goomba knockback
	DamageComponent.deal_knockback(self, damage_hitbox, damage)
	
	# Squish jump boost for the player
	if damage.type == DamageComponent.DAMAGE_TYPE.SQUISH:
		damage_hitbox.owner.vel.y = -3 # TODO This should also be done with the state machine
	
	hp -= damage.amount
	animate_damage(damage.type)

func animate_damage(damage_type: DamageComponent.DAMAGE_TYPE) -> void:
	# Disable the hitbox while the animation plays
	hitbox.disabled = true
	match damage_type:
		DamageComponent.DAMAGE_TYPE.STRIKE:
			anime.play(&"die_strike")
		_:
			anime.play(&"die_squish")
			
func check_health(_animation) -> void:
	if hp <= 0:
		ready_to_perish = true
	else:
		hitbox.disabled = false
		_reset_animation()


func _physics_process(delta):
	vel.y += gravity
	super(delta)
	
	## Die
	if is_on_floor() and vel.y >= 0 and ready_to_perish:
		queue_free()
 
func _on_hitbox_area_entered(area: Area2D) -> void:
	if Hitbox.can_harm_enemies(area):
		_take_hit(area)

# this can be made redundant after goombas are more flushed out
func _reset_animation() -> void:
	vel = Vector2.ZERO
	doll.scale = Vector2.ONE
