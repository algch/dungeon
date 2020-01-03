extends CanvasLayer

onready var hpBar = get_node('container/bars/bar/gauge')
onready var hpLabel = get_node('container/bars/bar/count/background/number')
onready var world_rect = get_node('../..').world_rect
onready var player = get_parent()

func updateUi():
	var percentage = floor(float(player.health) / player.MAX_HEALTH * 100)
	setHp(percentage, player.health, player.MAX_HEALTH)

func setHp(percentage, health, max_health):
	hpBar.set_value(percentage)
	hpLabel.set_text(str(health) + '/' + str(max_health))

func getRelativePlayerPosition():
	print('world_rect.position ', world_rect.position)
	print('player.position ', player.position)
	var relative_pos = (world_rect.position - player.position).abs()
	print('relative_pos ', relative_pos)
	return Vector2(
		relative_pos.x / world_rect.size.x,
		relative_pos.y / world_rect.size.y
	)

func _input(event):
	if event.is_action_pressed('ui_select'):
		var relative_pos = getRelativePlayerPosition()
		print('RELATIVE POS ', relative_pos)
