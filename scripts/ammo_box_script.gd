extends Node3D

@export var ammoValue: int
@onready var pick_up_SFX = $Pick_up_SFX
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		body.emit_signal("player_change_ammo", ammoValue)
		#pick_up_SFX.play()
		#await pick_up_SFX.finished
		queue_free()

	
