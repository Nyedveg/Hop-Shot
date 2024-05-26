extends Node3D

var collider_obj = preload( "res://prefabs/collider.tscn")

@onready var player = $Player

@export var startAmmo: int
signal set_ammo(setAmmo)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("set_ammo", startAmmo)

<<<<<<< HEAD
=======
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

>>>>>>> e4c1b3c7e3d6127ac1b3afbd249d65488d07f142
# A SIGNAL EMITTED BY THE PLAYER WHEN THE WEAPON GETS SHOT
func _on_player_player_shot_fired(pos, time):
	var collider = collider_obj.instantiate()
	collider.hold_timer = time
	add_child(collider)
	collider.position = pos

# CALLED WHEN PLAYER FALLS OUT OF THE MAP
func _on_death_zone_body_entered(body):
	print_debug("Player died. Respawning at 0,5,0")
	body.position = Vector3.ZERO + Vector3(0,5,0)
