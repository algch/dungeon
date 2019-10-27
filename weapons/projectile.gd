extends KinematicBody2D

var TYPE = 'WEAPON'
var SPEED = 10
var DAMAGE = 1
var move_dir = null
var bounces = 3

func _ready():
	$animation.play('default')
	move_dir = get_global_mouse_position() - position

func collisionLoop():
	for body in $hitbox.get_overlapping_bodies():
		if body.get('TYPE') != 'PLAYER':
			queue_free()

func movementLoop(delta):
	if bounces == 0:
		queue_free()

	var motion = move_dir.normalized() * SPEED
	var collision = move_and_collide(motion)
	if collision:
		move_dir = move_dir.bounce(collision.normal)
		bounces -= 1
		if collision.collider.has_method('takeDamage'):
			var knock_dir = collision.collider.transform.origin - transform.origin
			collision.collider.takeDamage(DAMAGE, knock_dir)
			queue_free()

func _physics_process(delta):
	movementLoop(delta)
	# collisionLoop()