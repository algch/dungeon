extends Node2D

var TYPE = 'WEAPON'
var SPEED = 1500
var DAMAGE = 1
var move_dir = null

func _ready():
	$animation.play('default')
	move_dir = get_global_mouse_position() - position

func collisionLoop():
	for body in $hitbox.get_overlapping_bodies():
		if body.get('TYPE') != 'PLAYER':
			queue_free()

func movementLoop(delta):
	var motion = move_dir.normalized() * SPEED * delta
	position += motion

func _physics_process(delta):
	movementLoop(delta)
	collisionLoop()