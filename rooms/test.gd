extends Node2D

var player_class = preload('res://player/player.tscn')
var incubator_class = preload('res://enemies/incubator/incubator.tscn')
var room_class = preload('res://rooms/room.tscn')

var TILE_SIZE = 64
var NUM_ROOMS = 50
var MIN_SIZE = 8
var MAX_SIZE = 16
var HSPREAD = 400
var CULL = 0.5

var path
var start_position

func _ready():
	randomize()

func makeRooms():
	for i in range(NUM_ROOMS):
		var pos = Vector2(rand_range(-HSPREAD, HSPREAD), 0)
		var r = room_class.instance()
		var w = MIN_SIZE + randi() % (MAX_SIZE - MIN_SIZE)
		var h = MIN_SIZE + randi() % (MAX_SIZE - MIN_SIZE)
		r.makeRoom(pos, Vector2(w, h) * TILE_SIZE)
		$rooms.add_child(r)
	# wait for movement to stop
	print('waiting...')
	yield(get_tree().create_timer(2), 'timeout')
	print('execution resumed after 2 secods')
	var room_positions = []
	var room_sizes = []
	# CULL rooms
	for room in $rooms.get_children():
		if randf() < CULL:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(
				Vector2(
					room.position.x,
					room.position.y
				)
			)
			room_sizes.append(
				Vector2(
					room.size.x,
					room.size.y
				)
			)

	yield(get_tree(), 'idle_frame')
	path = findMST(room_positions)
	for room in $rooms.get_children():
		room.queue_free()

	print('waiting...')
	yield(get_tree().create_timer(2), 'timeout')
	print('execution resumed after 2 secods')

	makeMap(room_positions, room_sizes)

func findMST(positions):
	var nodes = []
	for position in positions:
		nodes.append(
			Vector3(
				position.x,
				position.y,
				0
			)
		)
	# find minimum spanning tree
	var mst = AStar.new()
	mst.add_point(mst.get_available_point_id(), nodes.pop_front())

	while nodes:
		var min_dist = INF
		var min_p = null
		var p = null

		for global_point in mst.get_points():
			var global_point_pos = mst.get_point_position(global_point)
			for local_point in nodes:
				if global_point_pos.distance_to(local_point) < min_dist:
					min_dist = global_point_pos.distance_to(local_point)
					min_p = local_point
					p = global_point_pos

		var point_id = mst.get_available_point_id()
		mst.add_point(point_id, min_p)
		mst.connect_points(mst.get_closest_point(p), point_id)
		nodes.erase(min_p)

	return mst

func _draw():
	draw_rect(Rect2(get_global_mouse_position(), Vector2(10, 10)), Color(0, 1, 0), false)
	for room in $rooms.get_children():
		draw_rect(
			Rect2(room.position - room.size/2, room.size),
			Color(0, 1, 0),
			false
		)
	# if path:
	# 	for p in path.get_points():
	# 		for c in path.get_point_connections(p):
	# 			var pp = path.get_point_position(p)
	# 			var cp = path.get_point_position(c)
	# 			draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 0, 1), 2, true)
	if start_position:
		draw_rect(Rect2(start_position, Vector2(10, 10)), Color(1, 1, 0), false)
		

func _process(delta):
	update()

func _input(event):
	if event.is_action_pressed('ui_select'):
		path = null
		makeRooms()

	if event.is_action_pressed('ui_cancel'):
		spawnEnemies()
		var player = player_class.instance()
		add_child(player)
		player.position = start_position
		var camera = player.get_node('camera')
		camera.make_current()

func makeMap(room_positions, room_sizes):
	print('making map; rooms = ', $rooms.get_children())
	if len(room_positions) != len(room_sizes):
		print("ERROR room_positions) != len(room_sizes")
	var Map = $tilemap
	# create a tilemap from the generated rooms
	Map.clear()
	# fill tilemap with walls
	var full_rect = Rect2()
	for i in range(len(room_positions)):
		var r = Rect2(
			room_positions[i] - (room_sizes[i]/2),
			room_sizes[i]
		)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end + Vector2(1, 1))
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			Map.set_cell(x, y, getRandomWallTileId())

	var corridors = []
	for i in range(len(room_positions)):
		var room_size_in_tiles = (room_sizes[i] / TILE_SIZE).floor()
		var pos = Map.world_to_map(room_positions[i])
		var room_top_left = (room_positions[i] / TILE_SIZE).floor() - (room_size_in_tiles / 2).floor()
		for x in range(1, room_size_in_tiles.x - 1):
			for y in range(1, room_size_in_tiles.y - 1):
				Map.set_cell(room_top_left.x + x, room_top_left.y + y, getRandomFloorTileId())
		
		var room_point = path.get_closest_point(
			Vector3(
				room_positions[i].x,
				room_positions[i].y,
				0
			)
		)
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

	start_position = getStartPosition(room_positions)

func carvePath(start, end):
	var Map = $tilemap
	
	var x_step = 1 if start.x < end.x else -1
	var y_step = 1 if start.y < end.y else -1

	for x in range(start.x, end.x, x_step):
		Map.set_cell(x, start.y, getRandomFloorTileId())
		Map.set_cell(x, start.y + y_step, getRandomFloorTileId())
		Map.set_cell(x, start.y + 2*y_step, getRandomFloorTileId())

	for y in range(start.y, end.y+1, y_step):
		Map.set_cell(end.x, y, getRandomFloorTileId())
		Map.set_cell(end.x + x_step, y, getRandomFloorTileId())
		Map.set_cell(end.x + 2*x_step, y, getRandomFloorTileId())

func getStartPosition(room_positions):
	var left_most_room = null
	for room in room_positions:
		if left_most_room == null or room.x < left_most_room.x:
			left_most_room = room
	
	return left_most_room

func getRandomFloorTileId():
	return randi() % 2

func getRandomWallTileId():
	return randi() % 2 + 2

func spawnEnemies():
	print('spawning enemies')
	for room in $rooms.get_children():
		print(room.position)
		if randf() > 0.5 and room.position != start_position:
			var incubator = incubator_class.instance()
			incubator.position = room.position
			print('incubator added in room with position', room.position)
			add_child(incubator)



