extends 'res://engine/randomly_generated_map.gd'

var player_class = preload('res://player/player.tscn')

func _ready():
	randomize()
	connect('map_was_generated', self, 'instancePlayer')
	makeRooms()

func instancePlayer():
	var player = player_class.instance()
	add_child(player)
	player.position = start_position
	var camera = player.get_node('camera')
	camera.make_current()
