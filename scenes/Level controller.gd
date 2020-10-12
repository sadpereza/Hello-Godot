extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level_paths = [
	"res://scenes/levels/Level1.tscn",
	"res://scenes/levels/Level2.tscn",
	"res://scenes/levels/Level3.tscn",
	]

var levels = {}
var current_level: Node;

const START_LEVEL = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1, level_paths.size()+1):
		levels[i] = load(level_paths[i-1])
	_set_level(START_LEVEL)
	$Player.position = current_level.spawn_position
	$Player.paused = false
	$Player.doors_enabled = true

func _set_up_doors():
	var doors = get_tree().get_nodes_in_group("doors")
	print_debug("" + doors.size() as String + " doors found to connect")
	var successes = 0
	for d in doors:
		if not d.connect("body_entered", self, "_on_door_entered", [d]):
			successes += 1
	print_debug("" + successes as String + " doors connected successfully")


func _disconnect_doors():
	var doors = get_tree().get_nodes_in_group("doors")
	print_debug("" + doors.size() as String + " doors found to disconnect")
	for d in doors:
		d.disconnect("body_entered", self, "_on_door_entered")


func _on_door_entered(body: Node, door: Door):
	if body == $Player and $Player.doors_enabled == true:
		$Player.doors_enabled = false
		print_debug("moving to level " + door.destination_level as String)
		$Player.paused = true
		#_disconnect_doors()
		remove_child(current_level)
		$Player.position = door.destination_position
		_set_level(door.destination_level)
		$Player.doors_enabled = false #I dont know why i need to do this again but
		$Player.paused = false

func _set_level(level_id: int):
	current_level = levels[level_id].instance()
	add_child(current_level)
	_set_up_doors()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
