extends Node2D

var room = preload('res://rooms/room.tscn')

var tile_size = 32
var num_rooms = 50
var min_size = 4
var max_size = 10
var hspread = 400
var cull = 0.5

func _ready():
	randomize()
	makeRooms()

func makeRooms():
	for i in range(num_rooms):
		var pos = Vector2(rand_range(-hspread, hspread), 0)
		var r = room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.makeRoom(pos, Vector2(w, h) * tile_size)
		$rooms.add_child(r)
	# wait for movement to stop
	yield(get_tree().create_timer(1.1), 'timeout')
	# cull rooms
	for room in $rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC

func _draw():
	for room in $rooms.get_children():
		draw_rect(
			Rect2(room.position - room.size/2, room.size),
			Color(32, 228, 0),
			false
		)

func _process(delta):
	update()

func _input(event):
	if event.is_action_pressed('ui_select'):
		for room in $rooms.get_children():
			room.queue_free()
		makeRooms()
