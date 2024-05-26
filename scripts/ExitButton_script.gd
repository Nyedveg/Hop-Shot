extends Button

@onready var fade = $"../Fade"
var fading: bool = false
var timer: float = 0.0
@onready var menu_sound = $"../MenuSound"

func _physics_process(_delta):
	if fading:
		fade.color += Color(0, 0, 0, 0.01)
		timer += 0.01
		if timer >= 1:
			timer = 0
			get_tree().quit() 

func _on_pressed():
	menu_sound.play()
	fading = true
