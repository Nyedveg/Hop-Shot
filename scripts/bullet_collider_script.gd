extends CSGSphere3D

@export var x_speed = 7
@export var z_speed = 7
@export var y_speed = 12

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(0.1)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_3d_body_entered(body):
	if body.is_in_group("movable"):
		var projectile_vector = body.position - position
		body.velocity.y += projectile_vector.y * y_speed
		body.velocity.x += projectile_vector.x * x_speed
		body.velocity.z += projectile_vector.z * z_speed
		queue_free()


func _on_timer_timeout():
	queue_free()
