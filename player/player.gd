extends "res://engine/entity.gd"

onready var on_wall_texture = preload("res://player/on_wall.png")
onready var normal_texture = preload("res://player/player.png")

func _ready():
	SPEED = 100
	TYPE = 'PLAYER'

func _physics_process(delta):
	controls_loop()
	movement_loop()
	damage_loop()

	if is_on_wall():
		$sprite.set_texture(on_wall_texture)
		if movement_dir == Vector2(-1, 0) and test_move(transform, Vector2(-1, 0)):
			print('pared a la izquierda')
		if movement_dir == Vector2(1, 0) and test_move(transform, Vector2(1, 0)):
			print('pared a la derecha')
		if movement_dir == Vector2(0, -1) and test_move(transform, Vector2(0, -1)):
			print('pared a la arriba')
		if movement_dir == Vector2(0, 1) and test_move(transform, Vector2(0, 1)):
			print('pared a la abajo')
	else:
		$sprite.set_texture(normal_texture)
