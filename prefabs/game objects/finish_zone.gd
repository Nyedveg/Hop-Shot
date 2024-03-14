extends Area3D

var entered = false
# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	entered = true
	get_tree().change_scene_to_file("res://prefabs/levels/level_template.tscn")

func _on_body_exited(body):
	entered = false
