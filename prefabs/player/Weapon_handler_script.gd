extends Node3D

signal shot_fired(pos)
signal shake_camera(strength : float)
signal update_ammo(currentAmmo)

@onready var player = $"../.."
@onready var hand_anim = $"../Hand/AnimationPlayer"
@onready var aimcast = $"../AimCast"
@onready var shotSFX = $"../../../Shot_SFX"

var equipped: bool
@export var ammo: int

# Called when the node enters the scene tree for the first time.
func _ready():
	equipped = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	#WEAPON SHOOTING
	if Input.is_action_just_pressed("fire") && equipped && ammo > 0:
		shotSFX.play()
		if !hand_anim.is_playing():
			ammo -= 1
			hand_anim.play("firing_animation")
			emit_signal("update_ammo", ammo)
			emit_signal("shake_camera", 0.05)
			if aimcast.is_colliding() && aimcast.get_collider().is_in_group("shootable"):
				emit_signal("shot_fired", aimcast.get_collision_point())

# REDUNDANT UPDATER
func _on_player_equip_gun():
	equipped = true

# INCRAMENTS AMMO + UPDATES UI
func _on_player_player_change_ammo(ammoCount):
	ammo += ammoCount
	emit_signal("update_ammo", ammo)

# SETS AMMO + UPDATES UI
func _on_player_player_set_ammo(ammoCount):
	ammo = ammoCount
	emit_signal("update_ammo", ammo)

