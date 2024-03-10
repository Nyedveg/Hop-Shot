extends CharacterBody3D

# MOVEMENT SPEEDS.
var speed
# NORMAL SPEED.
var normal_speed = 10.0
# SPRINT/RUNING SPEED.
var sprint_speed = 20.0
# accel_in_air STANDS FOR ACCELERATION IN HANPPENING IN AIR. 
# accel_normal STANDS FOR ACCELERATION IN NOT HANPPENING IN AIR BUT INSTEAD ON GROUND.
const accel_normal = 10.0
const accel_in_air = 1.0
#THESE CONSTANTS DEFINE TWO ACCELERATION VALUES:
#THESE VALUES CONTROL HOW QUICKLY THE PLAYER SPEEDS UP AND SLOWS DOWN IN DIFFERENT CONTEXTS.
# ACCEL_NORMAL FOR WHEN THE PLAYER IS ON THE GROUND, AND ACCEL_IN_AIR FOR WHEN THE PLAYER IS IN THE AIR. 
# ACCEL IS ABOUT THE CURRENT ACCELERATION.
@onready var accel = accel_normal
# Get the gravity from the project settings to be synced with RigidBody nodes.
#GETS THE GRAVITY AND JUMPING VARIABLES.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jump_velocity #NO NEED TO SET JUMP VALUE BECAUSE THE CROUCH FUNCTIONS DOES IT'S VALUE Changing.
# LOWEST HEIGHT AND MAXIMUM.
var normal_height = 2.0
var crouch_height = 1.0
# LOWEST HEIGHT AND MAXIMUM TRANSITION SPEED OF CROUCHING.
var crouch_speed = 10.0
# CROUCH MOVEMENT SPEED
var crouch_move_speed = 5.0
# MOUSE SENSITIVITY.
var mouse_sense = 0.15
#IMPROTANT VARIABLES FOR PLAYER MOVEMENT.
var is_forward_moving = false
var direction = Vector3()
#WEAPON VARIABLES
var damage = 100

signal shot_fired(position)

# PLAYER.
@onready var head := $Head
@onready var camera3d := $Head/Camera3D
@onready var player_capsule := $CollisionShape3D
@onready var head_check := $Head_check
@onready var hand = $Head/Camera3D/Hand
@onready var aimcast = $Head/Camera3D/AimCast
@onready var hand_anim = $Head/Camera3D/Hand/AnimationPlayer

# Dictionary of weapon scenes
var weapons = {
	"weapon": {
		"weapon_scene": preload("res://weapons/weapon_hr.tscn"),
		"drop_scene": preload("res://weapons/weapon.tscn")
	}
	# Add more weapons here... ALSO DONT FORGET THE ,
}

func spawn_weapon(weapon_name):
	var weapon = weapons[weapon_name].weapon_scene.instantiate()
	weapon.position = hand.position
	hand.add_child(weapon)

# CALLED WHEN THE NODE ENTERS THE SCENE TREE FOR THE FIRST TIME.
func _ready():
	#HIDES THE CURSOR.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#CHECKS THE MOUSE MOVEMENT INPUT.
func _input(event):
	#GET MOUSE INPUT FOR CAMERA ROTATION AND CLAMP THE UP AND DOWN ROTATIONS.
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
		

func weapon_drop():
	if Input.is_action_just_pressed("interact"):
		if ! $Head/Camera3D/Hand.get_children().is_empty():
			var weapon_node = $Head/Camera3D/Hand.get_child(0)
			var weapon_name = weapon_node.name
			if weapons.has(weapon_name):
				var weapon_to_drop = weapons[weapon_name].drop_scene.instantiate()
				get_tree().get_root().add_child(weapon_to_drop)
				weapon_to_drop.global_transform = $Node3D.global_transform
				weapon_node.queue_free()

# CALLED EVERY FRAME. 'DELTA' IS THE ELAPSED TIME SINCE THE PREVIOUS FRAME.
# ALSO THIS WILL HANDLE ALL THE PLAYERS MOVEMENT AND PHYSICS.
func _physics_process(delta):
	weapon_drop()
	# ADDS CROUCHING TO THE PLAYER MEANING IT CALLS THE CROUCH FUNCTION WHICH WE MADE.
	crouch(delta)
	#WEAPON SHOOTING
	if Input.is_action_just_pressed("fire"):
		if !hand_anim.is_playing():
			hand_anim.play("firing_animation")
		if aimcast.is_colliding() && aimcast.get_collider().is_in_group("shootable"):
			emit_signal("shot_fired", aimcast.get_collision_point())
			var projectile_vector = position - aimcast.get_collision_point()
			velocity += projectile_vector / 10
		
	# IF ESCAPE IS PRESSED IT WILL SHOW THE MOUSE CURSOR.
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#GET KEYBOARD INPUT.
	direction = Vector3.ZERO
	speed = normal_speed
	# GETS KEYBOARD INPUT.
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
	if Input.is_action_pressed("crouch") and Input.is_action_pressed("sprint"):
		speed = normal_speed
	# ADDS JUMPING AND GRAVITY.
	if Input.is_action_pressed("crouch"):
		speed = crouch_move_speed
	if not is_on_floor():
		accel = accel_in_air
		velocity.y -= gravity * delta * 2
	else:
		accel = accel_normal
		velocity.y -= jump_velocity
	# HANDLES JUMP.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	# IF THE PLAYER PRESSES THE "jump" AND WHEN THE CHARACTER IS ON THE FLOOR,
	# SET THE Y VELOCITY TO THE JUMP VELOCITY.
	#	velocity.y = jump_velocity
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
		jump_velocity = 0.0
		player_capsule.shape.height -= crouch_speed * delta
	elif not colliding:
		# IT WILL INCREASE THE SIZE OF THE CAPSULE BY THE CROUCHING SPEED AND RESETS THE JUMP VALUE.
		sprint_speed = 10.0
		jump_velocity = 4.5
		player_capsule.shape.height += crouch_speed * delta
	player_capsule.shape.height = clamp(player_capsule.shape.height, crouch_height,normal_height)
