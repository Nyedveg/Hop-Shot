extends Node3D

signal shot_fired(pos, time)
signal shake_camera(strength : float)
signal update_ammo(currentAmmo)

@onready var player = $"../.."
@onready var hand_anim = $"../Hand/AnimationPlayer"
@onready var aimcast = $"../AimCast"
@onready var animated_crosshair = $"../Crosshair/AnimatedSprite2D"
@onready var collider_indicator = $"../Crosshair/Collider_indicator"
@onready var range_cast = $"../RangeCast"
@onready var shotSFX = $"../../../Shot_SFX"

var equipped: bool
var chargable: bool
var fire_timer : float = 0.0
var fire_cooldown: float = 0.0
@export var ammo: int

# Called when the node enters the scene tree for the first time.
func _ready():
	equipped = false
	chargable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#WEAPON SHOOTING
	if Input.is_action_pressed("fire") && equipped:
		if chargable:
			shotSFX.play()
			fire_timer += delta
			fire_timer = clamp(fire_timer, 0, 2.0)
			hand_anim.queue("charging_animation")
			if fire_timer == 2.0:
				animated_crosshair.play("charged")
			else:
				animated_crosshair.play("charging")
	if Input.is_action_just_released("fire") && equipped && ammo > 0:
		if fire_cooldown == 0:
			shotSFX.play()
			ammo -= 1
			hand_anim.play("firing_animation")
			fire_cooldown = 1/20
			animated_crosshair.play("idle")
			emit_signal("update_ammo", ammo)
			emit_signal("shake_camera", 0.05)
			if aimcast.is_colliding() && aimcast.get_collider().is_in_group("shootable"):
				emit_signal("shot_fired", aimcast.get_collision_point(), fire_timer)
		fire_timer = 0.0
	if range_cast.is_colliding() && range_cast.get_collider().is_in_group("shootable"):
		collider_indicator.visible = true
	else:
		collider_indicator.visible = false
	fire_cooldown -= delta
	fire_cooldown = clamp(fire_cooldown, 0, 1/20)

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

