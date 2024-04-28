extends Area3D

var transitioning: bool = false
var count: int = 0
@onready var color_rect = $"../../Control/ColorRect"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if transitioning:
		color_rect.color += Color(0, 0, 0, 0.01)
		count = count + 1
		if count == 100:
			get_tree().change_scene_to_file("res://prefabs/levels/testing_level/testing_level.tscn")


func _on_body_entered(body):
	if body.name == "Player":
		transitioning = true
