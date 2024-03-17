extends Node
var pressedW = false
var pressedA = false
var pressedS = false
var pressedD = false
var all_pressed = false
signal reverse_text()



@onready var text_pop = $"../TextPop"
@onready var spawn_in = $"../spawn_weapon"
@onready var player = $"../Player"
@onready var camera = $"../Player/Head/Camera"
@onready var cameraAnimation = $"../Player/Head/AnimationPlayer"
@onready var timer = $"../Random/Timer"
@onready var animationNode = $"../Floating_animation"
@onready var animationNode2 = $"../Floating_animation/AnimationPlayer"
var weapons = preload("res://prefabs/game objects/interactable/weapon/weapon.tscn")
var offset = Vector3(0,0.8,10)
@onready var label3 = $"../UI/RichTextLabel"
var original_text
@onready var crate = $"../Random/AmmoCreate"
@onready var cylinder = $"../Tube"
@onready var highlight_animation = $"../highlight_object"

var mouse_input = preload("res://prefabs/player/Player.gd")


var temp = 0




var ammoCratePosition = Vector3(0,0,5)


func spawn_weapon():
	var weapon = weapons.instantiate()
	weapon.position = offset

	print(spawn_in.position)
	spawn_in.add_child(weapon)
	text_pop.text = "Pick me up!"
	text_pop.visible = true
	spawn_in.add_child(text_pop)
	
func spawn_orb():
	crate.position = Vector3(0,0,5)
	crate.visible = true
	text_pop.text = "Take the ORB!"

	crate.add_child(text_pop)
	text_pop.translate(ammoCratePosition)
	crate.visible = true

func clear_txt():
	await reverse_text
	animationNode.play("text_type_reverse")

func _on_weapon_picked_up():
	text_pop.visible = false

func _on_player_change_ammo(ammo_value):
# Handle the signal here
	print("Ammo value changed:", ammo_value)
# Called when the node enters the scene tree for the first time.
func _ready():
	highlight_animation.queue("new_animation")
	text_pop.visible = false
	label3.visible = false
	crate.visible = false
	label3.bbcode_enabled = true
	label3.text = "Use to move:\nW - forwards\nA - left\nD - right\nS - backwards"
	
	
	original_text = label3.text
	set_player_pos_onready()
	set_camera_on_ready()
	set_player_pos_onready()
	
	timer.start()
	await timer.timeout
	animationNode.play("Text_type")
	label3.visible = true
	cameraAnimation.play("new_animation")
	

#func _on_player_change_ammo(value):
	#label3.text = "Ammo Value: " + str(value)

func set_camera_on_ready():
	camera.global_rotation_degrees = Vector3(-90,0,0)
func set_player_pos_onready():
	player.position = Vector3(0,30,20)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	if Input.is_action_just_pressed("move_backward"):
		pressedS = true
		var modify = original_text.replace("S - backwards", "[color=red]S - backwards[/color]")
		label3.bbcode_text = modify
		print("S")
		
		
	if Input.is_action_just_pressed("move_forward"):
		pressedW = true
		print(player.position)
		var modify = original_text.replace("W - forwards", "[color=red]W - forwards[/color]")
		label3.bbcode_text = modify
		print("W")
	if Input.is_action_just_pressed("move_right"):
		pressedD = true
		var modify = original_text.replace("D - right", "[color=red]D - right[/color]")
		label3.bbcode_text = modify
		print("D")
	if Input.is_action_just_pressed("move_left"):
		pressedA = true
		var modify = original_text.replace("A - left", "[color=red]A - left[/color]")
		label3.bbcode_text = modify
		print("A")
		
		
		
	if pressedS&&pressedW&&pressedD&&pressedA&&!all_pressed:
		all_pressed = true
		emit_signal("reverse_text")
		
		
		
		spawn_weapon()

		animationNode2.play("float_weapon")
		animationNode.play("text_type_3d")
		await animationNode.animation_finished
		animationNode.play("float")
		
		clear_txt()
		
		await player.equip_gun
		spawn_in.remove_child(text_pop)
		text_pop.visible = false
		spawn_orb()
		highlight_animation.play("new_animation")
		

		
		
		
		
		
		

		


