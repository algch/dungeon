extends Node2D

var room = preload('res://rooms/room.tscn')

var TILE_SIZE = 32
var NUM_ROOMS = 50
var MIN_SIZE = 8
var MAX_SIZE = 16
var HSPREAD = 400
var CULL = 0.5

var path

func _ready():
	randomize()
	makeRooms()

func makeRooms():
	for i in range(NUM_ROOMS):
		var pos = Vector2(rand_range(-HSPREAD, HSPREAD), 0)
		var r = room.instance()
		var w = MIN_SIZE + randi() % (MAX_SIZE - MIN_SIZE)
		var h = MIN_SIZE + randi() % (MAX_SIZE - MIN_SIZE)
		r.makeRoom(pos, Vector2(w, h) * TILE_SIZE)
		$rooms.add_child(r)
	# wait for movement to stop
	yield(get_tree().create_timer(2), 'timeout')
	var room_positions = []
	# CULL rooms
	for room in $rooms.get_children():
		if randf() < CULL:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(
				Vector3(
					room.position.x,
					room.position.y,
					0
				)
			)

	yield(get_tree(), 'idle_frame')
	path = findMST(room_positions)

func findMST(nodes):
	# find minimum spanning tree
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())

	while nodes:
		var min_dist = INF
		var min_p = null
		var p = null

		for global_point in path.get_points():
			var global_point_pos = path.get_point_position(global_point)
			for local_point in nodes:
				if global_point_pos.distance_to(local_point) < min_dist:
					min_dist = global_point_pos.distance_to(local_point)
					min_p = local_point
					p = global_point_pos

		var point_id = path.get_available_point_id()
		path.add_point(point_id, min_p)
		path.connect_points(path.get_closest_point(p), point_id)
		nodes.erase(min_p)

	return path


func _draw():
	for room in $rooms.get_children():
		draw_rect(
			Rect2(room.position - room.size/2, room.size),
			Color(0, 1, 0),
			false
		)
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 0, 1), 2, true)

func _process(delta):
	update()

func _input(event):
	if event.is_action_pressed('ui_select'):
		for room in $rooms.get_children():
			room.queue_free()
		path = null
		makeRooms()
	if event.is_action_pressed('ui_focus_next'):
		makeMap()

func makeMap():
	var Map = $tilemap
	# create a tilemap from the generated rooms
	Map.clear()
	# fill tilemap with walls
	var full_rect = Rect2()
	for room in $rooms.get_children():
		var r = Rect2(
			room.position-room.size/2,
			room.size
		)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			Map.set_cell(x, y, 0)

	var corridors = []
	for room in $rooms.get_children():
		var room_size_in_tiles = (room.size / TILE_SIZE).floor()
		var pos = Map.world_to_map(room.position)
		var room_top_left = (room.position / TILE_SIZE).floor() - (room_size_in_tiles / 2).floor()
		for x in range(1, room_size_in_tiles.x - 1):
			for y in range(1, room_size_in_tiles.y - 1):
				Map.set_cell(room_top_left.x + x, room_top_left.y + y, 2)
		
		var room_point = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for connection in path.get_point_connections(room_point):
			if not connection in corridors:
				var start = Map.world_to_map(
					Vector2(
						path.get_point_position(room_point).x,
						path.get_point_position(room_point).y
					)
				)
				var end = Map.world_to_map(
					Vector2(
						path.get_point_position(connection).x,
						path.get_point_position(connection).y
					)
				)

				carvePath(start, end)

		corridors.append(room_point)

func carvePath(start, end):
	var Map = $tilemap
	
	var x_step = 1 if start.x < end.x else -1
	var y_step = 1 if start.y < end.y else -1

	for x in range(start.x, end.x, x_step):
		Map.set_cell(x, start.y, 2)
		Map.set_cell(x, start.y + y_step, 2)

	for y in range(start.y, end.y+1, y_step):
		Map.set_cell(end.x, y, 2)
		Map.set_cell(end.x + x_step, y, 2)
