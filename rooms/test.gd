extends 'res://engine/randomly_generated_map.gd'

var player_class = preload('res://player/player.tscn')
var spawner_class = preload('res://engine/Spawner/Spawner.tscn')

func _ready():
	randomize()
	connect('map_was_generated', self, 'instancePlayer')
	makeRooms()

func instancePlayer():
	var spawner = spawner_class.instance()
	spawner.position = start_position
	add_child(spawner)

	var player = player_class.instance()
	player.position = start_position
	add_child(player)
