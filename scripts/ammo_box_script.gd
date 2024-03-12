extends Node3D

@export var ammoValue: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_area_3d_body_entered(body):
	body.emit_signal("player_change_ammo", ammoValue)
	queue_free()
