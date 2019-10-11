extends KinematicBody2D

var SPEED = 0
var movement_dir = Vector2(0, 0)

func controls_loop():
	var RIGHT = int(Input.is_action_pressed("ui_right"))
	var LEFT = int(Input.is_action_pressed("ui_left"))
	var DOWN = int(Input.is_action_pressed("ui_down"))
	var UP = int(Input.is_action_pressed("ui_up"))

	movement_dir.x = -LEFT + RIGHT
	movement_dir.y = -UP + DOWN

func movement_loop():
	var motion = movement_dir.normalized() * SPEED
	move_and_slide(motion)
