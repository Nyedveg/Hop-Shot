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
@onready var label3 = $"../Label"
var crate = preload("res://prefabs/game objects/interactable/ammo_create.tscn")
@onready var door = $"../Doors"


#SFX
@onready var SFX = $"../SFX"
@onready var AHSH = $"../spawn_weapon/Ah_shit"
@onready var lightON = $"../spawn_weapon/light_on"

@onready var colorRect = $"../Random/ColorRect"
#Good node
@onready var animation_Player_Node = $"../AnimationPlayerNode"
@onready var collisionArea = $"../Area3D"
@onready var collisionArea1 = $"../Area3D2"
@onready var HUD = $"../UI"
@onready var spotLight = $"../SpotLight3D"

var Finish = preload("res://prefabs/game objects/static/finish_zone.tscn")


func spawn_weapon():
	var weapon = weapons.instantiate()
	spawn_in.add_child(weapon)
	player._on_level_template_set_ammo(100)
	
	

func spawn_orb():
	var instance = crate.instantiate()
	spawn_in_orb.position = Vector3(0,0,-16)
	spawn_in_orb.add_child(instance)
	spawn_in_orb.ammoValue = 10
	
	
func spawn_finish():
	var instance = Finish.instantiate()
	add_child(instance)
	
	

func _on_player_colided_with_collision_area(collision_area: Area3D):
	var player_detected = false
	print(collision_area.position)
	if collision_area.get_overlapping_bodies().size() > 0:
		for body in collision_area.get_overlapping_bodies():
			if  body.is_in_group("movable"):
				player_detected = true
				break
	return player_detected
	
	
func change_collision_area_pos(x,y,z, collision_area: Object):
	collision_area.position = Vector3(x,y,z)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	text_pop.visible = false
	player.set_mouse_input_enabled(false)
	HUD.visible = false
	set_player_pos_onready(0,100,20)
	cameraAnimation.play("new_animation")
	cameraAnimation.seek(0)
	cameraAnimation.pause()
	
	
	animation_Player_Node.play("opacity")
	
	label3.visible = false
	animationNode.play("Text_type")
	label3.text = "Press W to move forwards"
	
	timer.start()
	await timer.timeout
	cameraAnimation.play()
	HUD.visible = true
	player.set_mouse_input_enabled(true)
	animationNode.play("Text_type")
	label3.visible = true

func enter_pointer_text(text: String):
	text_pop.text = text


func text_pop_change_position(x,y,z):
	text_pop.position = Vector3(x,y,z)

	
func set_player_pos_onready(x,y,z):
	player.position = Vector3(x,y,z)
	
func finish_line_scene(String):
	Finish.scene
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var playerDetected = _on_player_colided_with_collision_area(collisionArea)
	if playerDetected:
		HUD.update_objective(str(playerDetected), false)
		animation_Player_Node.play("close")
		SFX.play()
		change_collision_area_pos(-100,100,0,collisionArea)
		pass
	
	if Input.is_action_just_pressed("move_backward") and !pressedS:
		pressedS = true
		label3.text = "Press D to move right"
		
	if Input.is_action_just_pressed("move_forward") and !pressedW:
		pressedW = true
		label3.text = "Press S to move backwards"
		
	if Input.is_action_just_pressed("move_right") and !pressedD:
		pressedD = true
		label3.text = "Press A to move left"
		
	if Input.is_action_just_pressed("move_left") and !pressedA:
		pressedA = true
		label3.text =""
		
		
	if pressedS&&pressedW&&pressedD&&pressedA&&!all_pressed:
		all_pressed = true

		
		#Weapon spawns
		player.set_mouse_input_enabled(false)
		timer.wait_time = 2
		timer.start()
		cameraAnimation.play("shake")
		
		await timer.timeout
		lightON.play()
		spotLight.visible = true
		text_pop.visible = true
		spawn_weapon()
		camera.look_at_from_position(camera.global_transform.origin,spawn_in.global_position)
		cameraAnimation.play("zoom")
		timer.wait_time = 0.5
		timer.start()
		await timer.timeout
		
		AHSH.play()
		await AHSH.finished
		
		player.set_mouse_input_enabled(true)
		enter_pointer_text("Pick me up!")
		animation_Player_Node.play("Rattlesanek")
		text_pop_change_position(spawn_in.position.x, 1.2,spawn_in.position.z)
		HUD.update_objective("pick up the 'thing'?", false)
		
		await player.equip_gun
		#spawn_in.queue_free()
		enter_pointer_text("")
		HUD.update_objective("pick up the 'thing'?", true)
		
		spotLight.visible = false
		timer.wait_time = 1.5
		timer.start()
		await timer.timeout
		
		#Orb spawns
		spotLight.visible = true
		lightON.play()
		spotLight.position = Vector3(spawn_in_orb.position.x, spotLight.position.y, spawn_in_orb.position.z)
		spawn_orb()
		enter_pointer_text("Pick this up!")
		text_pop_change_position(spawn_in_orb.position.x, 1.2, spawn_in_orb.position.z)
		timer.wait_time = 0.5
		timer.start()
		await timer.timeout
		HUD.update_objective("Do what it says...", false)
		
		await player.UI_update_ammo
		enter_pointer_text("")
		timer.wait_time = 1
		timer.start()
		await timer.timeout
		

		text_pop_change_position(0,5.5,-20)
		enter_pointer_text("Get up here!")
		HUD.update_objective("Get up there... NOW!", false)
		
		
		var playerDetected1 = _on_player_colided_with_collision_area(collisionArea1)
		if playerDetected1:
			HUD.update_objective(str(playerDetected1), false)
		text_pop_change_position(0,6.5,-25)
		enter_pointer_text("Get up here!")
		
		

		
		
		
		

		
		
		
		
		
		

		


