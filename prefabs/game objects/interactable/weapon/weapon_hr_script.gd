extends Node3D

var ammo: int

@onready var ammo_label = $AmmoLabel
var handler_node

# Called when the node enters the scene tree for the first time.
func _ready():
	handler_node = get_parent().get_parent().find_child("Weapon_handler")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Changes the text on the gun screen
	ammo_label.text = str(handler_node.ammo)
	#Changes the text color when gun is low on ammo
	if handler_node.ammo <= 3:
		ammo_label.set_modulate(Color(0.886, 0.024, 0.0, 1.0))
	else:
		ammo_label.set_modulate(Color(0.667, 0.906, 0.773, 1.0))
