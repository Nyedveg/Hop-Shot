extends Node3D

var collider_obj = preload( "res://prefabs/collider.tscn")


@onready var speed_label = $UI/SpeedLabel
@onready var player = $Player
@onready var ammo_label = $UI/AmmoLabel


@export var startAmmo: int
signal set_ammo(setAmmo)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("set_ammo", startAmmo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# A SIGNAL EMITTED BY THE PLAYER WHEN THE WEAPON GETS SHOT
func _on_player_shot_fired(pos):
	var collider = collider_obj.instantiate()
	add_child(collider)
	collider.position = pos

# CALLED WHEN PLAYER FALLS OUT OF THE MAP
func _on_death_zone_body_entered(body):
	print_debug("Player died. Respawning at 0,5,0")
	body.position = Vector3.ZERO + Vector3(0,5,0)
	
