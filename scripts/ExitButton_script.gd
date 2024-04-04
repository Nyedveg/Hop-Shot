extends Button

@onready var fade = $"../Fade"
var fading: bool = false
var timer: float = 0.0

func _physics_process(delta):
	if fading:
		fade.color += Color(0, 0, 0, 0.01)
		timer += 0.01
		if timer >= 1:
			timer = 0
			get_tree().quit() 

func _on_pressed():
	fading = true
