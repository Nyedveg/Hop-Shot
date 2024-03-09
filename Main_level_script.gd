extends Node3D

var collider_obj = preload( "res://collider.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_shot_fired(position):
	var collider = collider_obj.instantiate()
	add_child(collider)
	collider.position = position
