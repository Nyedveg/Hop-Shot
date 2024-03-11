extends Node
var pressedW = false
var pressedA = false
var pressedS = false
var pressedD = false
var all_pressed = false
@onready var text_pop = $"../TextPop"
@onready var spawn_in = $"../spawn_weapon"
@onready var text_animation = $"../TextPop/AnimationPlayer"
var weapons = preload("res://weapons/weapon.tscn")
var weapon_spawn_position = Vector3(0,0.8,-5)

func spawn_weapon():
	var weapon = weapons.instantiate()
	weapon.position = weapon_spawn_position
	spawn_in.add_child(weapon)
		# Calculate the position for text_pop
	var text_offset = weapon_spawn_position  # Adjust this offset as needed
	text_pop.global_transform.origin = weapon_spawn_position #+ Vector3(0,0.7,0)
	
	
	
	# Add text_pop as a child of spawn_in to make it relative to it
	spawn_in.add_child(text_pop)
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	text_pop.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("move_backward"):
		pressedS = true
		print("S")
	if Input.is_action_just_pressed("move_forward"):
		pressedW = true
		print("W")
	if Input.is_action_just_pressed("move_right"):
		pressedD = true
		print("D")
	if Input.is_action_just_pressed("move_left"):
		pressedA = true
		print("A")
		
	if pressedS&&pressedW&&pressedD&&pressedA&&!all_pressed:
		all_pressed = true
		text_pop.visible = true
		text_animation.play("text_float")
		spawn_weapon()
		print("spawn_in position:", text_pop.position)
		
		
		
		
		
