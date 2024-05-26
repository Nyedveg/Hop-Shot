extends Area3D

@export var scene: String
var entered = false

# Called when the node enters the scene tree for the first time.
func _on_body_entered(_body):
	entered = true
	call_deferred("change_level")

func _on_body_exited(_body):
	entered = false

func change_level():
	get_tree().change_scene_to_file(scene)
