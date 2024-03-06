extends CharacterBody3D

#Movement variables
const MAX_SPEED = 5.0
const MAX_SPEED_AIR = 3.5
const GROUND_ACCEL = 35
const AIR_ACCEL = 25
const FRICTION = 3.5
const JUMP_VELOCITY = 4.5
#Camera Variables
@export var sensitivity = 0.5
@export var yRotationLimit = 90
@onready var camPivot = $Neck


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x  * sensitivity))
		camPivot.rotation_degrees.x += -event.relative.y  * sensitivity
		camPivot.rotation_degrees.x = clamp(camPivot.rotation_degrees.x, -yRotationLimit, yRotationLimit)
		
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("fire"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		velocity = accelerate(direction, delta, GROUND_ACCEL, MAX_SPEED)
		#Apply friction
		var speed = velocity.length()
		if speed != 0:
			var drop = speed * FRICTION * delta
			velocity *= max(speed - drop, 0) / speed
		# Handle Jump.
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	else:
		velocity = accelerate(direction, delta, AIR_ACCEL, MAX_SPEED_AIR)
		velocity.y -= gravity * delta
		
	move_and_slide()
	
func accelerate(dir, delta, accel_type, max_velocity):
	var proj_vel = velocity.dot(dir)
	var accel_vel = accel_type * delta
	
	if (proj_vel + accel_vel > max_velocity):
		accel_vel = max_velocity - proj_vel
	
	return velocity + (dir * accel_vel)
