extends Node
var pressedW = false
var pressedA = false
var pressedS = false
var pressedD = false
var all_pressed = false



@onready var text_pop = $"../TextPop"
@onready var spawn_in = $"../spawn_weapon"
@onready var player = $"../Player"
var weapons = preload("res://prefabs/game objects/interactable/weapon/weapon.tscn")
var offset = Vector3(0,0.8,-5)
@onready var label3 = $"../UI/RichTextLabel"
var original_text
@onready var crate = $"../Random/AmmoCreate"

var temp = 0



var ammoCratePosition = Vector3(0,0.8,10)

func spawn_weapon():
	var weapon = weapons.instantiate()
	weapon.position = offset
	spawn_in.add_child(weapon)
	
func _on_weapon_picked_up():
	text_pop.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	text_pop.visible = false
	label3.visible = true
	crate.position = ammoCratePosition
	label3.bbcode_enabled = true
	label3.text = "Use to move:\nW - forwards\nA - left\nD - right\nS - backwards"
	
	original_text = label3.text
	
	if crate.has_node("ammo_box_script"):
		var ammoBox = crate.get_node("ammo_box_script")
		label3.text = "Ammo Value: " + str(ammoBox.ammoValue)
		#crate.connect("player_change_ammo", self, "_on_player_change_ammo")
		temp = ammoBox.ammoValue
		print("DDDDDDDDDDDD" + ammoBox.ammoValue)
	else:
		print("ammo_box_script not found")
	

	

func _on_player_change_ammo(value):
	label3.text = "Ammo Value: " + str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("move_backward"):
		pressedS = true
		var modify = original_text.replace("S - backwards", "[color=red]S - backwards[/color]")
		label3.bbcode_text = modify
		print("S")
		
		
	if Input.is_action_just_pressed("move_forward"):
		pressedW = true
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
		text_pop.visible = true
		
		
		
		
		
		
		
		
		
		
		
		
		
		spawn_weapon()
		


