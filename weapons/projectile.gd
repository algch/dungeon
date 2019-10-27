extends KinematicBody2D

var TYPE = 'WEAPON'
var SPEED = 10
var DAMAGE = 1
var move_dir = null
var bounces = 5

func _ready():
	$animation.play('default')
	move_dir = get_global_mouse_position() - position

func explode():
	print('BOOM')
	# TODO create and explosion node (collision shape linked to animation)
	# and destroy everything inside the explosion area
	queue_free()

func movementLoop(delta):
	if bounces == 0:
		queue_free()

	var motion = move_dir.normalized() * SPEED
	var collision = move_and_collide(motion)
	if collision:
		if collision.collider.get('TYPE') == 'WEAPON':
			explode()
			collision.collider.queue_free()
		else:
			move_dir = move_dir.bounce(collision.normal)
			bounces -= 1

func _physics_process(delta):
	movementLoop(delta)