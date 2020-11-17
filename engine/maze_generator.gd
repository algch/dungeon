extends Node2D

class Cell:
	var x
	var y
	var size = 40
	var visited = false

	var up_wall = true
	var down_wall = true
	var left_wall = true
	var right_wall = true

	func _init(_x, _y):
		self.x = _x
		self.y = _y

	func get_rect():
		return Rect2(
			Vector2(self.x*self.size, self.y*self.size),
			Vector2(self.size, self.size)
		)

var cells = []
var rows = 10
var cols = 10

func _ready():
	randomize()
	populate_cells()
	var current_cell = cells[0]
	carve_maze(current_cell)

func populate_cells():
	for i in range(rows):
		for j in range(cols):
			cells.append(Cell.new(j, i))

func carve_maze(current_cell):
	current_cell.visited = true
	var neighbors = get_neighbors(current_cell)
	while neighbors:
		var elem_index = randi() % len(neighbors)
		var rand_neighbor = neighbors[elem_index]
		neighbors.remove(elem_index)
		if not rand_neighbor.visited:
			remove_wall(current_cell, rand_neighbor)
			carve_maze(rand_neighbor)

func get_neighbors(cell):
	var neighbors = []

	var up_neighbor_index = _get_cell_index(cell.x, cell.y - 1)
	var down_neighbor_index = _get_cell_index(cell.x, cell.y + 1)
	var left_neighbor_index = _get_cell_index(cell.x - 1, cell.y)
	var right_neighbor_index = _get_cell_index(cell.x + 1, cell.y)

	if up_neighbor_index:
		neighbors.append(cells[up_neighbor_index])
	if down_neighbor_index:
		neighbors.append(cells[down_neighbor_index])
	if left_neighbor_index:
		neighbors.append(cells[left_neighbor_index])
	if right_neighbor_index:
		neighbors.append(cells[right_neighbor_index])

	return neighbors

func remove_wall(current, neighbor):
	var x_delta = neighbor.x - current.x
	if x_delta == 1:
		current.right_wall = false
		neighbor.left_wall = false
	elif x_delta == -1:
		current.left_wall = false
		neighbor.right_wall = false

	var y_delta = neighbor.y - current.y
	if y_delta == 1:
		current.down_wall = false
		neighbor.up_wall = false
	elif y_delta == -1:
		current.up_wall = false
		neighbor.down_wall = false

func _get_cell_index(x, y):
	if x < 0 or x > cols-1 or y < 0 or y > rows-1:
		return null

	return x + y * cols

func _draw():
	for cell in cells:
		if cell.up_wall:
			draw_line(Vector2(cell.x*cell.size, cell.y*cell.size), Vector2((cell.x+1)*cell.size, cell.y*cell.size), Color(1, 1, 1), 2)
		if cell.right_wall:
			draw_line(Vector2((cell.x+1)*cell.size, cell.y*cell.size), Vector2((cell.x+1)*cell.size, (cell.y+1)*cell.size), Color(1, 1, 1), 2)
		if cell.down_wall:
			draw_line(Vector2((cell.x+1)*cell.size, (cell.y+1)*cell.size), Vector2(cell.x*cell.size, (cell.y+1)*cell.size), Color(1, 1, 1), 2)
		if cell.left_wall:
			draw_line(Vector2(cell.x*cell.size, (cell.y+1)*cell.size), Vector2(cell.x*cell.size, cell.y*cell.size), Color(1, 1, 1), 2)

func _process(delta):
	update()

func _unhandled_input(event):
	if event.is_action_released("refresh"):
		reset_cells()
		carve_maze(cells[0])

func reset_cells():
	for cell in cells:
		cell.left_wall = true
		cell.right_wall = true
		cell.up_wall = true
		cell.down_wall = true
		cell.visited = false
