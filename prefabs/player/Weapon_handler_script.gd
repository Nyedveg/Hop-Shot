extends Node3D

signal shot_fired(pos)
signal shake_camera(strength : float)
signal update_ammo(currentAmmo)

@onready var player = $"../.."
@onready var hand_anim = $"../Hand/AnimationPlayer"
@onready var aimcast = $"../AimCast"
@onready var shotSFX = $"../../../Shot_SFX"
@onready var chargeSFX = $"../../../SFX_CHARGE"

var equipped: bool
@export var ammo: int

# Called when the node enters the scene tree for the first time.
func _ready():
	equipped = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
<<<<<<< Updated upstream
func _physics_process(_delta):
	#WEAPON SHOOTING
	if Input.is_action_just_pressed("fire") && equipped && ammo > 0:
		shotSFX.play()
		if !hand_anim.is_playing():
=======
var charging = true
func _physics_process(delta):
	#WEAPON SHOOTING
	if Input.is_action_pressed("fire") && equipped && charging:
		chargeSFX.play()
		fire_timer += delta
		fire_timer = clamp(fire_timer, 0, 2.0)
		hand_anim.queue("charging_animation")
		if fire_timer == 2.0:
			animated_crosshair.play("charged")
			chargeSFX.stop()
		else:
			animated_crosshair.play("charging")
	else:
		pass
	if Input.is_action_just_released("fire") && equipped && ammo > 0:
		if fire_cooldown == 0:
			shotSFX.play()
>>>>>>> Stashed changes
			ammo -= 1
			hand_anim.play("firing_animation")
			emit_signal("update_ammo", ammo)
			emit_signal("shake_camera", 0.05)
			if aimcast.is_colliding() && aimcast.get_collider().is_in_group("shootable"):
<<<<<<< Updated upstream
				emit_signal("shot_fired", aimcast.get_collision_point())
=======
				emit_signal("shot_fired", aimcast.get_collision_point(), fire_timer)
		fire_timer = 0.0

	fire_cooldown -= delta
	fire_cooldown = clamp(fire_cooldown, 0, 1/20)
>>>>>>> Stashed changes

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

