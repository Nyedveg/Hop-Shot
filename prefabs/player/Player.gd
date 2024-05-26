extends CharacterBody3D

# MOVEMENT SPEEDS.
var speed
@export var normal_speed = 8.0
@export var sprint_speed = 15.0

const accel_normal = 10.0 #STANDS FOR ACCELERATION ON GROUND.
const accel_in_air = 0.8 # STANDS FOR ACCELERATION IN HANPPENING IN AIR. 

# ACCEL IS ABOUT THE CURRENT ACCELERATION.
@onready var accel = accel_normal

#GETS THE GRAVITY AND JUMPING VARIABLES.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jump_velocity #NO NEED TO SET JUMP VALUE BECAUSE THE CROUCH FUNCTIONS DOES IT'S VALUE Changing.
# LOWEST HEIGHT AND MAXIMUM.
var normal_height = 3.0
var crouch_height = 1.5
# LOWEST HEIGHT AND MAXIMUM TRANSITION SPEED OF CROUCHING.
var crouch_speed = 10.0
# CROUCH MOVEMENT SPEED
var crouch_move_speed = 5.0
# MOUSE SENSITIVITY.
@export var mouse_sense = 0.15
#IMPROTANT VARIABLES FOR PLAYER MOVEMENT.
var is_forward_moving = false
var direction = Vector3()

#BOB Variables
const bob_freq = 2.0
const bob_amp = 0.08
var t_bob = 0.0

signal player_shot_fired(pos : Vector3)
signal equip_gun()
signal player_set_ammo(ammoCount : int)
signal player_change_ammo(ammoCount : int)
signal UI_update_ammo(currentAmmo : int)

# PLAYER.
@onready var head := $Head
@onready var player_capsule := $CollisionShape3D
@onready var head_check := $Head_check
@onready var hand = $Head/Camera/Hand


#Mouse input
var enabled_mouse_input = true

# Dictionary of weapon scenes
var weapons = {
	"weapon": {
		"weapon_scene": preload("res://prefabs/game objects/interactable/weapon/weapon_hr.tscn"),
		"drop_scene": preload("res://prefabs/game objects/interactable/weapon/weapon.tscn")
	}
}

func spawn_weapon(weapon_name):
	var weapon = weapons[weapon_name].weapon_scene.instantiate()
	weapon.position = hand.position
	hand.add_child(weapon)
	emit_signal("equip_gun")

# CALLED WHEN THE NODE ENTERS THE SCENE TREE FOR THE FIRST TIME.
func _ready():
	#HIDES THE CURSOR.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#CHECKS THE MOUSE MOVEMENT INPUT.
func _input(event):
	#GET MOUSE INPUT FOR CAMERA ROTATION AND CLAMP THE UP AND DOWN ROTATIONS.
	if not enabled_mouse_input:
		return
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))


func set_mouse_input_enabled(enabled: bool):
	enabled_mouse_input = enabled
	
	
# CALLED EVERY FRAME. 'DELTA' IS THE ELAPSED TIME SINCE THE PREVIOUS FRAME.
# ALSO THIS WILL HANDLE ALL THE PLAYERS MOVEMENT AND PHYSICS.
func _physics_process(delta):
	
	# ADDS CROUCHING TO THE PLAYER MEANING IT CALLS THE CROUCH FUNCTION WHICH WE MADE.
	crouch(delta)
	
	#HEAD BOB
	t_bob += delta * velocity.length() * float(is_on_floor())
	head.transform.origin = headbob(t_bob)
	
	# IF ESCAPE IS PRESSED IT WILL SHOW THE MOUSE CURSOR.
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	#GET KEYBOARD INPUT.
	direction = Vector3.ZERO
	# GET THE INPUT DIRECTION AND HANDLE THE MOVEMENT/DECELERATION.
	# AS GOOD PRACTICE, YOU SHOULD REPLACE UI ACTIONS WITH CUSTOM GAMEPLAY ACTIONS.
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_direction.y < 0.0:
		is_forward_moving = true
	else:
		is_forward_moving = false
	direction = (transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()
	
	#SWITCHING BETWEEN SPEEDS 
	if Input.is_action_pressed("sprint") and is_forward_moving:
		speed = sprint_speed
	elif Input.is_action_pressed("crouch") and Input.is_action_pressed("sprint"):
		speed = normal_speed
		
	# ADDS JUMPING AND GRAVITY.
	elif Input.is_action_pressed("crouch"):
		speed = crouch_move_speed
	else:
		speed = normal_speed
		
	if not is_on_floor():
		accel = accel_in_air
		velocity.y -= gravity * delta * 2
	else:
		accel = accel_normal
		
	#MAKES IT MOVE.
	velocity = velocity.lerp(direction * speed, accel * delta)
	#MOVES THE BODY BASED ON VELOCITY.
	move_and_slide()

# THE CROUCH FUNCTION.
func crouch(delta):
	var colliding = false
	if head_check.is_colliding():
		colliding = true
	if Input.is_action_pressed("crouch"):
		# IT WILL LOWER THE SIZE OF THE CAPSULE BY THE CROUCHING SPEED AND DECREASES THE JUMP VALUE AND ,
		# SETS SPEED TO NORMAL SPEED. 
		sprint_speed = 5.0
		player_capsule.shape.height -= crouch_speed * delta
	elif not colliding:
		# IT WILL INCREASE THE SIZE OF THE CAPSULE BY THE CROUCHING SPEED AND RESETS THE JUMP VALUE.
		sprint_speed = 15.0
		player_capsule.shape.height += crouch_speed * delta
	player_capsule.shape.height = clamp(player_capsule.shape.height, crouch_height,normal_height)

# BOB FUNCTION
func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos
	
# SHOT SPAWNING PASSTHROUGH FORM WEAPON HANDLER
func _on_weapon_handler_shot_fired(pos, time):
	emit_signal("player_shot_fired", pos, time)

# UI UPDATER PASSTHROUGH FOR UPDATING AMMO COUNT
func _on_weapon_handler_update_ammo(currentAmmo):
	emit_signal("UI_update_ammo", currentAmmo)

# MAIN SCENE PASSTHROUGH FOR SETTING BULLET COUNT
func _on_level_template_set_ammo(setAmmo):
	emit_signal("player_set_ammo", setAmmo)
		
