extends Node3D

@onready var camera = $"../Camera"
@onready var player = $"../.."
@onready var animation = $"../AnimationPlayer"

@export var default_fov: float

@export var shakeFade: float = 15.0

var rng = RandomNumberGenerator.new()

var randomStrength: float
var shake_strength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.is_forward_moving:

		camera.fov = default_fov + player.velocity.length() / 3
	elif not player.is_on_floor():
		camera.fov = default_fov + player.velocity.length() / 3
	else:
		camera.fov = lerp(camera.fov, default_fov, shakeFade * delta)
	
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		
		camera.h_offset = rndOffset().x
		camera.v_offset = rndOffset().y

func rndOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength), rng.randf_range(-shake_strength,shake_strength))
	
func apply_shake():
	shake_strength = randomStrength

func _on_weapon_handler_shake_camera(strength):
	camera.fov += 2
	randomStrength = strength
	apply_shake()
