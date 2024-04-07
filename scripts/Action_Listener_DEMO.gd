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
@onready var spawn_Finish = $"../Random/Finish_Line"
@onready var player = $"../Player"
@onready var camera = $"../Player/Head/Camera"
@onready var cameraAnimation = $"../Player/Head/AnimationPlayer"
@onready var timer = $"../Random/Timer"
@onready var animationNode = $"../Floating_animation"
@onready var animationNode2 = $"../Floating_animation/AnimationPlayer"
var weapons = preload("res://prefabs/game objects/interactable/weapon/weapon_hr.tscn")
var offset = Vector3(0,0.8,0)
@onready var label3 = $"../UI/RichTextLabel"
var original_text
var crate = preload("res://prefabs/game objects/interactable/ammo_create.tscn")
@onready var cylinder = $"../Tube"
@onready var highlight_animation = $"../highlight_object"
var finish_line = preload("res://prefabs/game objects/static/finish_zone.tscn")
@onready var UI = $"../UI"

var mouse_input = preload("res://prefabs/player/Player.gd")


var temp = 0


func spawn_weapon():
	var weapon = weapons.instantiate()
	spawn_in.position = offset
	
	print(spawn_in.position)
	spawn_in.add_child(weapon)
	text_pop.text = "Pick me up!"
	
func spawn_finish():
	var finish = finish_line.instantiate()
	spawn_Finish.add_child(finish)

func camera_opacity():
	pass

func spawn_orb():
	var instance = crate.instanciate()
	instance.position = Vector3(0,0,5)
	text_pop.text = "Pick this up!"
	crate.emit_signal("orb_spawned")

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
	
	label3.visible = false
	label3.bbcode_enabled = true
	label3.text = "Use to move:\nW - forwards\nA - left\nD - right\nS - backwards"
	
	
	original_text = label3.text
	set_player_pos_onready(0,100,20)
	set_camera_on_ready(-90,0,0)
	
	timer.start()
	await timer.timeout
	animationNode.play("Text_type")
	label3.visible = true
	cameraAnimation.play("new_animation")
	set_camera_on_ready(0,0,0)
	
	

#func _on_player_change_ammo(value):
	#label3.text = "Ammo Value: " + str(value)

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
		

		animationNode.play("text_type_3d")
		await animationNode.animation_finished
		animationNode.play("float")
		
		
		
		await player.equip_gun
		#text_pop.visible = false
		
		spawn_orb()
		
		await crate.has_signal("orb_spawn")
		print("")
		animationNode.stop()
		text_pop_change_position(0,0,5)
		
		

		
		
		
		
		
		

		


