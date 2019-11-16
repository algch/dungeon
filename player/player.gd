extends "res://engine/entity.gd"

onready var on_wall_texture = preload("res://player/on_wall.png")
onready var normal_texture = preload("res://player/player.png")
var DAMAGE = 3

func healthLoop():
	if health <= 0:
		gameOver()

func animationLoop():
	var state = 'walk'
	if hitstun > 0:
		$animation.play('damaged')
	elif movement_dir == Vector2(0, 0):
		$animation.play(state + '_' + sprite_dir)
		$animation.stop()
		$animation.set_frame(0)
	else:
		$animation.play(state + '_' + sprite_dir)

func gameOver():
	get_tree().quit()

func _ready():
	randomize()
	SPEED = 200
	TYPE = 'PLAYER'
	$animation.stop()
	health = 5

func _physics_process(delta):
	controlsLoop()
	movementLoop()
	damageLoop(['ENEMY', 'WEAPON'])
	spriteDirLoop()
	animationLoop()
	attackLoop()
	healthLoop()
