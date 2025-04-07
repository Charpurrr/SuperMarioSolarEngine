@tool
extends Control


@export var coin_count: int:
	set(val):
		coin_count = clamp(val, 0, INF)

		if is_instance_valid(label):
			_update_label()

@export_custom(PROPERTY_HINT_NONE, "suffix:px") var bounce_height: int = 3
@export var bounce_color: Color = Color.YELLOW

@export_category("References")
@export var label: Label

var call_count: int = 0


func _ready() -> void:
	var root: Window = get_tree().root

	if not root.has_user_signal(&"coin_collected"):
		root.add_user_signal(&"coin_collected")

	root.connect(&"coin_collected", _increment)


func _increment(type: Coin.COIN_TYPE):
	match type:
		Coin.COIN_TYPE.YELLOW:
			bounce_color = 0xffc800ff
			coin_count += 1
		Coin.COIN_TYPE.BLUE:
			bounce_color = 0x0034ffff
			coin_count += 5
		Coin.COIN_TYPE.RED:
			bounce_color = 0xff0000ff
			coin_count += 2


func _update_label() -> void:
	label.text = str(coin_count).pad_zeros(3)
	label.position.y = -bounce_height
	label.modulate = bounce_color

	call_count += 1

	while (label.position.y != 0 or label.modulate != Color.WHITE) and call_count == 1:
		var delta: float = get_process_delta_time()
		label.position.y = Math.lerp_fr(label.position.y, 0, 15 * delta, 0.01)
		label.modulate = Math.lerp_colr(label.modulate, Color.WHITE, 5 * delta, 0.01)
		await Engine.get_main_loop().process_frame

	call_count -= 1
