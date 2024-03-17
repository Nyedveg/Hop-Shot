extends PanelContainer

@onready var property_container = $MarginContainer/VBoxContainer

var property
var frames_per_second : String 

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
	add_debug_property("FPS",frames_per_second)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		frames_per_second = "%.2f" % (1.0/delta) # Gets fps
		property.text = property.name + ": " + frames_per_second

func _input(event):
	# Toggle debug panel
	if event.is_action_pressed("debug"):
		visible = !visible

# Callable function to add new debug preperty
func add_debug_property(title : String, value):
	property = Label.new() # Create new Label node
	property_container.add_child(property) # Add new mode as child to VBox container
	property.name = title # Set name to title
	property.text = property.name + value
