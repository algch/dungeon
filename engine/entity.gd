extends KinematicBody2D

var TYPE = 'ENTITY'

var SPEED = 0
var movement_dir = Vector2(0, 0)

var hitstun = 0
var knock_dir = Vector2(0, 0)

var health = 1

func damage_loop():
	if hitstun > 0:
		hitstun -= 1
	for body in $hitbox.get_overlapping_bodies():
		if hitstun == 0 and body.get('DAMAGE') != null and body.get('TYPE') != TYPE:
			health -= body.get('DAMAGE')
			hitstun = 10
			knock_dir = transform.origin - body.transform.origin


func controls_loop():
	var RIGHT = int(Input.is_action_pressed("ui_right"))
	var LEFT = int(Input.is_action_pressed("ui_left"))
	var DOWN = int(Input.is_action_pressed("ui_down"))
	var UP = int(Input.is_action_pressed("ui_up"))

	movement_dir.x = -LEFT + RIGHT
	movement_dir.y = -UP + DOWN

func movement_loop():
	var motion
	if hitstun == 0:
		motion = movement_dir.normalized() * SPEED
	else:
		motion = knock_dir.normalized() * SPEED * 1.5
	move_and_slide(motion)
