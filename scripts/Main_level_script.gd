extends Node3D

var collider_obj = preload( "res://prefabs/collider.tscn")
@onready var speed_label = $SpeedLabel
@onready var player = $Player
@onready var ammo_label = $AmmoLabel

@export var startAmmo: int
signal set_ammo(setAmmo)
signal change_ammo(ammoCount)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("set_ammo", startAmmo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	speed_label.text = var_to_str(player.velocity)

# A signal emmited by the player, when the weapon gets shot
func _on_player_player_shot_fired(pos):
	var collider = collider_obj.instantiate()
	add_child(collider)
	collider.position = pos
	startAmmo -= 1

func _on_death_zone_body_entered(body):
	print("You died")
	body.position = Vector3.ZERO + Vector3(0,5,0)

func _on_ammo_create_change_ammo(ammoCount):
	emit_signal("change_ammo", ammoCount)

func _on_player_player_update_ammo(currentAmmo):
	ammo_label.text = var_to_str(currentAmmo)
