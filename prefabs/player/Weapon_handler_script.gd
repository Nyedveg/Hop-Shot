extends Node3D

signal shot_fired(pos)

@onready var player = $"../.."
@onready var hand_anim = $"../Camera3D/Hand/AnimationPlayer"
@onready var aimcast = $"../Camera3D/AimCast"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	#WEAPON SHOOTING
	if Input.is_action_just_pressed("fire"):
		if !hand_anim.is_playing():
			hand_anim.play("firing_animation")
			if aimcast.is_colliding() && aimcast.get_collider().is_in_group("shootable"):
				emit_signal("shot_fired", aimcast.get_collision_point())
				var projectile_vector = position - aimcast.get_collision_point()
				player.velocity += projectile_vector / 10
