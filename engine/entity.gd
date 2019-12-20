extends KinematicBody2D

var TYPE = 'ENTITY'

onready var projectile_class = preload('res://weapons/projectile.tscn')

# TESTING
onready var explosion_class = preload('res://weapons/explosion.tscn')

var SPEED = 0
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

func takeDamage(damage, body):
	if hitstun == 0:
		health -= damage
		hitstun = HITSTUN_TIME
		knock_dir = transform.origin - body.transform.origin

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
	var motion
	if hitstun == 0:
		motion = movement_dir.normalized() * SPEED
	else:
		motion = knock_dir.normalized() * SPEED * 1.5
	move_and_slide(motion)

func damageLoop(damage_types):
	if hitstun > 0:
		hitstun -= 1
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if body.get('TYPE') in damage_types:
			var damage = body.get('DAMAGE') or 0
			takeDamage(body.get('DAMAGE'), body)

func controlsLoop():
	var RIGHT = int(Input.is_action_pressed('ui_right'))
	var LEFT = int(Input.is_action_pressed('ui_left'))
	var DOWN = int(Input.is_action_pressed('ui_down'))
	var UP = int(Input.is_action_pressed('ui_up'))

	movement_dir.x = -LEFT + RIGHT
	movement_dir.y = -UP + DOWN

	is_attacking = Input.is_action_just_released('attack')


func attackLoop():
	if reload > 0:
		reload -= 1
	elif is_attacking and hitstun == 0:
		# create projectile outside of the player
		var start_pos = (get_global_mouse_position() - position).normalized() * 54
		var projectile = projectile_class.instance()
		projectile.position = position + start_pos
		get_parent().add_child(projectile)
		is_attacking = false
		reload = RELOAD_TIME
