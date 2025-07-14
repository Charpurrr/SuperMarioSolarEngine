@tool
extends ColorRect

class_name TransitionOverlay

#The base class for all transition overlays. To be instanced in a scene file along with an AnimationPlayer. For a list of all available transitions, see scene_transition.gd
#IMPORTANT: Any new overlays MUST have a child AnimationPlayer with an animation named "transition" to work properly!

@onready var default_color = self.color

@onready var animation: AnimationPlayer = $AnimationPlayer

func play_transition(custom_color: Color = default_color, speed_scale:float = 1.0, play_backwards: bool = false,):
	self.color = custom_color
	var direciton = -1 + (2*int(!play_backwards)) #converts bool (1 to 0) into 1 to -1
	animation.play("transition", -1, abs(speed_scale) * direciton, play_backwards)
