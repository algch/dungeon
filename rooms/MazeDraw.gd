extends Node2D


func _draw():
	var cells = get_node("..").cells
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
