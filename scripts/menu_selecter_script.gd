extends Area3D

@onready var collision_shape_3d = $CollisionShape3D
@onready var label_3d = $Label3D
@export var scene: String

@onready var fade = $"../../UIMainMenu/Fade"
@onready var menu_sound = $"../../UIMainMenu/MenuSound"

var fading: bool = false
var timer: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if fading:
		fade.color += Color(0, 0, 0, 0.01)
		timer += 0.01
		if timer >= 1:
			timer = 0
			call_deferred("change_level")

func change_level():
	get_tree().change_scene_to_file(scene)

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			fading = true
			menu_sound.play()

func _on_mouse_entered():
	label_3d.set_modulate(Color(0.0, 1.0, 0.1, 1.0))

func _on_mouse_exited():
	label_3d.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
