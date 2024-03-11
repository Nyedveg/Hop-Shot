extends Node3D

@export var ammoValue: int
signal change_ammo(ammoCount)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_area_3d_body_entered(body):
	emit_signal("change_ammo", ammoValue)
	queue_free()
