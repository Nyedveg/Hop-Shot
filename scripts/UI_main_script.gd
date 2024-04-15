extends Control

@onready var ammo_label = $AmmoLabel
@onready var speed_label = $SpeedLabel
@onready var level = $".."
@onready var player = $"../Player"
@onready var timer_label = $Timer_label
@onready var timer = $Timer_label/Timer
@onready var objective = $objective
@onready var animation = $AnimationPlayer

var timer_running = false
var elapsed_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ammo_label.text = var_to_str(level.startAmmo)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	speed_label.text = var_to_str(ceil(player.velocity.length()))

func _on_player_ui_update_ammo(currentAmmo):
	ammo_label.text = var_to_str(currentAmmo)
	
func _on_Timer_timeout():
	elapsed_time += 1
	update_timer_text()
	
func update_timer_text():
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time % 60)
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func update_objective(enter_objective: String, clear: bool):
	var temp = Timer.new()
	if clear:
		animation.play("text_clear")
		await animation.animation_finished
		change_objective_color(false)
	else:
		objective.text = "Objective: \n" + enter_objective
		animation.play("Text_type")
		
func change_objective_color(reset: bool):
	if reset:
		objective.modulate = Color(0,1,0)
	else:
		objective.modulate = Color(1,1,1)
	
