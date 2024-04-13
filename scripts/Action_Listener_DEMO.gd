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
@onready var player = $"../Player"
@onready var camera = $"../Player/Head"
@onready var cameraAnimation = $"../Player/Head/AnimationPlayer"
@onready var timer = $"../Random/Timer"
@onready var animationNode = $"../Floating_animation"
var weapons = preload("res://prefabs/game objects/interactable/weapon/weapon.tscn")
@onready var label3 = $"../RichTextLabel"
var original_text
var crate = preload("res://prefabs/game objects/interactable/ammo_create.tscn")
@onready var door = $"../CSGBox3D15"


#SFX
@onready var SFX = $"../CSGBox3D15/SFX"
@onready var AHSH = $"../spawn_weapon/Ah_shit"

@onready var colorRect = $"../Random/ColorRect"
#Good node
@onready var animation_Player_Node = $"../AnimationPlayerNode"
@onready var collisionArea = $"../Area3D"
@onready var HUD = $"../UI"
var Finish = preload("res://prefabs/game objects/static/finish_zone.tscn")


func spawn_weapon():
	var weapon = weapons.instantiate()
	spawn_in.add_child(weapon)
	player._on_level_template_set_ammo(10)
	text_pop.text = "Pick me up!"
	

func spawn_orb():
	var instance = crate.instantiate()
	spawn_in_orb.position = Vector3(0,0,5)
	spawn_in_orb.add_child(instance)
	text_pop.text = "Pick this up!"
	
func spawn_finish():
	var instance = Finish.instantiate()
	add_child(instance)
	
	

func _on_player_colided_with_collision_area(collision_area):
	var playerDetected = false
	if collisionArea.get_overlapping_bodies().size() > 0:
		for body in collisionArea.get_overlapping_bodies():
			if body.name == "Player":
				playerDetected = true
				break
	return playerDetected
	
	
func change_collision_area_pos(new_pos: Vector3):
	collisionArea.position = new_pos
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
	
func create_timer(wait_time: float, is_started: bool):
	var timer = Timer.new()
	timer.wait_time = wait_time
	timer.one_shot = true #timer triggers only once
	add_child(timer)
	if is_started:
		timer.start()

func enter_pointer_text(text: String):
	text_pop.text = text


func text_pop_change_position(x,y,z):
	text_pop.position = Vector3(x,y,z)

	
func set_player_pos_onready(x,y,z):
	player.position = Vector3(x,y,z)
	
func finish_line_scene(String):
	Finish.scene
	
func _on_animation_timer_timeout():
	# Animate the position of the text_pop node
	text_pop.position.y = (text_pop.position.y + 0.05) % 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var playerDetected = false
	playerDetected = _on_player_colided_with_collision_area(collisionArea)
	if playerDetected:
		door.position.y = 7
		SFX.play()
		change_collision_area_pos(Vector3(0,0,-100))
	playerDetected = false


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

		
		#Weapon spawns
		player.set_mouse_input_enabled(false)
		timer.wait_time = 2
		timer.start()
		cameraAnimation.play("shake")
		
		await timer.timeout
		spawn_weapon()
		camera.look_at_from_position(camera.global_transform.origin,spawn_in.global_position)
		cameraAnimation.play("zoom")
		AHSH.play()
		await AHSH.finished
		
		player.set_mouse_input_enabled(true)
		text_pop_change_position(spawn_in.position.x, 1.2,spawn_in.position.z)
		#Orb spawns
		spawn_orb()
		enter_pointer_text("Pick me up!")
		#animation_Player_Node.play("Rattlesanek")
		
		await player.equip_gun
		
		
		
		
		
		text_pop_change_position(spawn_in_orb.position.x, 1.2, spawn_in_orb.position.z)

		
		
		
		

		
		
		
		
		
		

		


