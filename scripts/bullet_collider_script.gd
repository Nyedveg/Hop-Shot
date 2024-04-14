extends CSGSphere3D

@onready var timer = $Timer
@export var hold_timer: float

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(0.1)
	
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_area_3d_body_entered(body):
	if body.is_in_group("movable"):
		var projectile_direction = (body.position - position).normalized()
		var projectile_knockback = 10 + (26 * hold_timer)
		
		var add_velocity = projectile_direction * projectile_knockback
		body.velocity += add_velocity
		queue_free()


func _on_timer_timeout():
	queue_free()
