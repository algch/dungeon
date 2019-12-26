extends CanvasLayer

onready var hpBar = get_node('container/bars/bar/gauge')
onready var hpLabel = get_node('container/bars/bar/count/background/number')
onready var player = get_parent()

func updateUi():
	var percentage = floor(float(player.health) / player.MAX_HEALTH * 100)
	setHp(percentage, player.health, player.MAX_HEALTH)

func setHp(percentage, health, max_health):
	hpBar.set_value(percentage)
	hpLabel.set_text(str(health) + '/' + str(max_health))
