extends KinematicBody2D

onready var on_wall_texture = preload("res://player/on_wall.png")
onready var normal_texture = preload("res://player/player.png")

var DAMAGE = 3
var MAX_HEALTH = 5
var current_weapon = null
var health = 5 setget set_health
var movement_dir = Vector2()
var SPEED = 350

var moving_left = false
var moving_right = false
var moving_up = false
var moving_down = false

func set_health(new_health):
	health = new_health

	if health <= 0:
		gameOver()

func animationLoop():
	var facing = ""
	if abs(movement_dir.angle_to(Vector2.UP)) < PI/4:
		facing = "up"
	elif abs(movement_dir.angle_to(Vector2.DOWN)) < PI/4:
		facing = "down"
	elif abs(movement_dir.angle_to(Vector2.LEFT)) < PI/4:
		facing = "left"
	elif abs(movement_dir.angle_to(Vector2.RIGHT)) < PI/4:
		facing = "right"

	if movement_dir:
		if facing:
			$animation.play("walk_" + facing)
	else:
		$animation.set_frame(0)
		$animation.stop()

func gameOver():
	get_tree().quit()

func _ready():
	randomize()
	health = MAX_HEALTH
	$camera.make_current()

func _draw():
	# draw_line(Vector2(0,0), get_global_mouse_position()-position, Color('#ff0000'), true)
	draw_line(Vector2(0,0), movement_dir*100, Color('#ff00ff'), true)

func _unhandled_input(event):
	if event.is_action_pressed("move_left"):
		moving_left = true
	if event.is_action_released("move_left"):
		moving_left = false
	if event.is_action_pressed("move_right"):
		moving_right = true
	if event.is_action_released("move_right"):
		moving_right = false
	if event.is_action_pressed("move_up"):
		moving_up = true
	if event.is_action_released("move_up"):
		moving_up = false
	if event.is_action_pressed("move_down"):
		moving_down = true
	if event.is_action_released("move_down"):
		moving_down = false

	if event.is_action_released("shoot"):
		action_weapon()

func action_weapon():
	if current_weapon:
		current_weapon.action()

func movementLoop():
	var x_axis = 0
	if moving_left:
		x_axis -= 1
	if moving_right:
		x_axis += 1

	var y_axis = 0
	if moving_up:
		y_axis -= 1
	if moving_down:
		y_axis += 1

	movement_dir = Vector2(x_axis, y_axis).normalized()
	var motion = movement_dir * SPEED
	move_and_slide(motion)

func _physics_process(delta):
	movementLoop()
	animationLoop()
	update()
