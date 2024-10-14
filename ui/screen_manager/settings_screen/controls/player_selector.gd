extends ScrollContainer

@export var settings_for_player: int = 1

@onready var options = $Spacings/Options


func _ready():
	options.player = settings_for_player
