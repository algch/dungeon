extends KinematicBody2D

var explosion_class = preload('res://weapons/explosion.tscn')

var TYPE = 'WEAPON'
var SPEED = 10
var DAMAGE = 1
var move_dir = null
var bounces = 5

func _ready():
	$animation.play('default')
	move_dir = get_global_mouse_position() - position

func explode():
	if is_queued_for_deletion():
		return

	var explosion = explosion_class.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	queue_free()

func movementLoop(delta):
	if bounces == 0:
		queue_free()

	var motion = move_dir.normalized() * SPEED
	var collision = move_and_collide(motion)
	if collision:
		if collision.collider.get('TYPE') == 'WEAPON':
			collision.collider.queue_free()
			explode()
		else:
			move_dir = move_dir.bounce(collision.normal)
			bounces -= 1

func _physics_process(delta):
	movementLoop(delta)