extends Area3D

var transitioning: bool = false
@onready var color_rect = $"../../Control/ColorRect"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if transitioning:
		color_rect.color += Color(0, 0, 0, 0.01)


func _on_body_entered(body):
	if body.name == "Player":
		transitioning = true
