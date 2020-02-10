extends Position2D

onready var player = get_node('../..')

# TODO get room_positions and path from "randomly_generated_map.gd"
onready var world_rect = get_node('../../..').world_rect

onready var screen_size = get_viewport().get_visible_rect().size
onready var minimap_size = screen_size - position

func _ready():
	print(screen_size)
	print(position)
	print(minimap_size)

func _process(delta):
	update()

func getMinimapPlayerPosition():
	var relative_pos = (world_rect.position - player.position).abs()
	var minimap_x_pos = (relative_pos.x / world_rect.size.x) * minimap_size.x
	var minimap_y_pos = (relative_pos.y / world_rect.size.y) * minimap_size.y
	return Vector2(minimap_x_pos, minimap_y_pos)

# TODO draw rooms and paths
func _draw():
	draw_rect(
		Rect2(
			Vector2(0, 0),
			screen_size
		),
		Color('dd77ff'),
		false
	)
	var minimap_pos = getMinimapPlayerPosition()
	draw_rect(
		Rect2(
			minimap_pos,
			Vector2(5, 5)
		),
		Color('ff2030')
	)
