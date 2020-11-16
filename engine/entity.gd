extends KinematicBody2D

var TYPE = 'ENTITY'

onready var projectile_class = preload('res://weapons/projectile.tscn')

# TESTING
onready var explosion_class = preload('res://weapons/explosion.tscn')

signal player_damaged

var SPEED = 0
var KNOCK_SPEED = 0
var movement_dir = Vector2(0, 0)

var hitstun = 0
var HITSTUN_TIME = 10

var reload = 0
var RELOAD_TIME = 25

var knock_dir = Vector2(0, 0)

var sprite_dir = 'down'

var is_attacking = false

var health = 1

func getDistanceToPlayer():
	var player = get_node('../player')
	if player:
		return (player.position - position).length()

	return -1

func setDamagedTexture():
	pass

func takeDamage(damage, body):
	if hitstun == 0:
		health -= damage
		hitstun = HITSTUN_TIME
		knock_dir = transform.origin - body.transform.origin
		# TODO make this better
		if TYPE == 'PLAYER':
			emit_signal('player_damaged')
		elif TYPE == 'ENEMY':
			setDamagedTexture()

func spriteDirLoop():
	match movement_dir:
		Vector2(-1, 0):
			sprite_dir = 'left'
		Vector2(1, 0):
			sprite_dir = 'right'
		Vector2(0, -1):
			sprite_dir = 'up'
		Vector2(0, 1):
			sprite_dir = 'down'

func movementLoop():
	var motion = movement_dir.normalized() * SPEED
	move_and_slide(motion)
