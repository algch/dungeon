extends KinematicBody2D

var explosion_class = preload('res://weapons/explosion.tscn')

var TYPE = 'WEAPON'
var SPEED = 100
var DAMAGE = 1
var move_dir = null

signal collided(collider)

func init(_move_dir):
	move_dir = _move_dir

func _ready():
	$animation.play('default')

func movementLoop(delta):
	if not move_dir:
		return

	var motion = move_dir.normalized() * SPEED * delta
	var collision = move_and_collide(motion)
	if collision:
		emit_signal("collided", collision.collider)
		queue_free()

func _physics_process(delta):
	movementLoop(delta)
