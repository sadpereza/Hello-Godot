extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var temp: String
	
	var vy = $"..".get_v().y as String
	temp = "vy = " + vy
	
	var doors = $"..".doors_enabled as String
	temp += "\ndoors_enabled = " + doors
	
	var coyote = $"..".coyote_time as String
	temp += "\ncoyote time = " + coyote
	
	var jump_speed = $"..".JUMP_SPEED as String
	temp += "\njump speed = " +jump_speed
	
	text = temp
