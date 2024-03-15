extends Control

@onready var ammo_label = $AmmoLabel
@onready var speed_label = $SpeedLabel
@onready var level = $".."
@onready var player = $"../Player"
@onready var fov = $FOV

# Called when the node enters the scene tree for the first time.
func _ready():
	ammo_label.text = var_to_str(level.startAmmo)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	speed_label.text = var_to_str(ceil(player.velocity.length()))
	fov.text = var_to_str(player.camera3d.fov)

func _on_player_ui_update_ammo(currentAmmo):
	ammo_label.text = var_to_str(currentAmmo)
