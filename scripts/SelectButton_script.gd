extends Button

@export var scene: String
var fading: bool = false
var timer: float = 0.0
@onready var fade = $"../Fade"

func _on_pressed():
	fading = true

func change_level():
	get_tree().change_scene_to_file(scene)

func _physics_process(delta):
	if fading:
		fade.color += Color(0, 0, 0, 0.01)
		timer += 0.01
		if timer >= 1:
			timer = 0
			call_deferred("change_level")
