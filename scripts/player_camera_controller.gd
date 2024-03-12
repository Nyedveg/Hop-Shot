extends Node3D

@onready var camera = $"../Camera"
@onready var player = $"../.."

@export var default_fov: int

@export var shakeFade: float = 15.0

var rng = RandomNumberGenerator.new()

var randomStrength: float
var shake_strength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.fov = default_fov + player.velocity.length() / 2
	
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		
		camera.h_offset = rndOffset().x
		camera.v_offset = rndOffset().y

func rndOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength), rng.randf_range(-shake_strength,shake_strength))
	
func apply_shake():
	shake_strength = randomStrength

func _on_weapon_handler_shake_camera(strength):
	randomStrength = strength
	apply_shake()
