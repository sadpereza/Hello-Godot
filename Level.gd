extends TileMap

class_name Level

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var level_id
export (Vector2) var spawn_position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_id() -> int:
	return level_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
