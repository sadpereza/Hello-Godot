extends Area2D

class_name Door_Enabler
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
	if body.name == "Player":
		body.set_doors_enabled(true)
		print_debug("enabled doors")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
