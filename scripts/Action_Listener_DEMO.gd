extends Node
var pressedW = false
var pressedA = false
var pressedS = false
var pressedD = false
var all_pressed = false

signal reverse_text
signal orb_spawned


@onready var text_pop = $"../TextPop"
@onready var spawn_in = $"../spawn_weapon"
@onready var spawn_in_orb = $"../Random/orb"
@onready var spawn_Finish = $"../Random/Finish_Line"
@onready var player = $"../Player"
@onready var camera = $"../Player/Head/Camera"
@onready var cameraAnimation = $"../Player/Head/AnimationPlayer"
@onready var timer = $"../Random/Timer"
@onready var animationNode = $"../Floating_animation"
@onready var animationNode2 = $"../Floating_animation/AnimationPlayer"
var weapons = preload("res://prefabs/game objects/interactable/weapon/weapon.tscn")
var offset = Vector3(0,0.8,0)
@onready var label3 = $"../RichTextLabel"
var original_text
var crate = preload("res://prefabs/game objects/interactable/ammo_create.tscn")
@onready var cylinder = $"../Tube"
@onready var highlight_animation = $"../highlight_object"
var finish_line = preload("res://prefabs/game objects/static/finish_zone.tscn")
@onready var colorRect = $"../Random/ColorRect"
#Good node
@onready var animation_Player_Node = $"../AnimationPlayerNode"
@onready var collisionArea = $"../Area3D"
@onready var HUD = $"../UI"


var temp = 0


func spawn_weapon():
	var weapon = weapons.instantiate()
	spawn_in.position = offset
	
	print(spawn_in.position)
	spawn_in.add_child(weapon)
	player._on_level_template_set_ammo(0)
	text_pop.text = "Pick me up!"
	
func spawn_finish():
	var finish = finish_line.instantiate()
	spawn_Finish.add_child(finish)

func camera_opacity():
	pass

func spawn_orb():
	var instance = crate.instantiate()
	spawn_in_orb.position = Vector3(0,0,5)
	spawn_in_orb.add_child(instance)
	text_pop.text = "Pick this up!"
	

func clear_txt():
	await reverse_text
	animationNode.play("text_type_reverse")

func _on_weapon_picked_up():
	text_pop.visible = false
	
	
func _on_player_colided_with_collision_area(collision_area):
	var playerDetected = false
	if collisionArea.get_overlapping_bodies().size() > 0:
		for body in collisionArea.get_overlapping_bodies():
			if body.name == "Player":
				playerDetected = true
				break
	return playerDetected
		
	

# Called when the node enters the scene tree for the first time.
func _ready():
	player.set_mouse_input_enabled(false)
	HUD.visible = false
	set_player_pos_onready(0,100,20)
	cameraAnimation.play("new_animation")
	cameraAnimation.seek(0)
	cameraAnimation.pause()
	
	collisionArea.position = Vector3(1,1,1)
	animation_Player_Node.play("opacity")
	
	label3.visible = false
	label3.bbcode_enabled = true
	label3.text = "Use to move:\nW - forwards\nA - left\nD - right\nS - backwards"
	
	
	
	original_text = label3.text
	
	
	timer.start()
	await timer.timeout
	cameraAnimation.play()
	HUD.visible = true
	player.set_mouse_input_enabled(true)
	animationNode.play("Text_type")
	label3.visible = true
	
	
	



func text_pop_change_position(x,y,z):
	text_pop.position = Vector3(x,y,z)

func set_camera_on_ready(x,y,z):
	camera.global_rotation_degrees = Vector3(x,y,z)
	
func set_player_pos_onready(x,y,z):
	player.position = Vector3(x,y,z)
	
func finish_line_scene(String):
	finish_line.change_level(String)
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var playerDetected = false
	playerDetected = _on_player_colided_with_collision_area(collisionArea)
	if playerDetected:
		pass
	else:
		pass


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
		clear_txt()
		
		spawn_weapon()
		spawn_orb()
		
		animationNode.play("text_type_3d")
		await animationNode.animation_finished
		animationNode.play("float")
		
		
		
		await player.equip_gun
		
		
		#text_pop.visible = false
		
		
		
		
		
		text_pop_change_position(0,0,5)
		spawn_finish()
		
		

		
		
		
		
		
		

		


