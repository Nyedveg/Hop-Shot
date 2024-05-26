extends Button

@onready var animation_player = $"../../Camera3D/AnimationPlayer"
var trans: bool = true
@onready var menu_sound = $"../MenuSound"

func _on_pressed():
	menu_sound.play()
	if trans:
		change_level()
		trans = false

func change_level():
	animation_player.play("pan")
