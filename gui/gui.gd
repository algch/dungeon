extends CanvasLayer

onready var hpBar = get_node('container/bars/bar/gauge')
onready var hpLabel = get_node('container/bars/bar/count/background/number')

func _ready():
	connect('player_damaged', self, 'updateUi')

func updateUi():
	print('updating ui')
	var player = get_node('../player')
	var percentage = floor(player.health / player.MAX_HEALTH * 100)
	setHp(percentage, player.health)

func setHp(percentage, health):
	hpBar.set_value(percentage)
	hpLabel.set_text(str(health))
