extends KinematicBody2D

onready var on_wall_texture = preload("res://player/on_wall.png")
onready var normal_texture = preload("res://player/player.png")

var DAMAGE = 3
var MAX_HEALTH = 5
var current_weapon = null
var health = 5
var movement_dir = Vector2()
var SPEED = 100

func healthLoop():
	if health <= 0:
		gameOver()

func animationLoop():
	var state = 'walk'

func gameOver():
	get_tree().quit()

func _ready():
	randomize()
	SPEED = 200
	health = MAX_HEALTH
	get_node('gui').updateUi()
	$camera.make_current()

func _draw():
	draw_line(Vector2(0,0), get_global_mouse_position()-position, Color('#ff0000'), true)

func _unhandled_input(event):
	var movement = movement_dir

	if event.is_action_pressed("move_left"):
		movement += Vector2(-1, 0)
	if event.is_action_pressed("move_right"):
		movement += Vector2(1, 0)
	if event.is_action_pressed("move_up"):
		movement += Vector2(0, -1)
	if event.is_action_pressed("move_down"):
		movement += Vector2(0, 1)

	if event.is_action_released("shoot"):
		action_weapon()

	print("movement ", movement)

	movement_dir = movement.normalized()

func action_weapon():
	if current_weapon:
		current_weapon.action()

func movementLoop():
	var motion = movement_dir.normalized() * SPEED
	move_and_slide(motion)

func _physics_process(delta):
	movementLoop()
	animationLoop()
	healthLoop()
	update()
