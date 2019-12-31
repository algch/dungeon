extends "res://engine/entity.gd"

const MOVEMENT_TIME = 50
var movementtimer = 0
var damaged_texture = preload('res://enemies/spider/animations/spider_damaged.png')
var normal_texture = preload('res://enemies/spider/animations/spider.png')

var DAMAGE = 1

var texture_timer = null

func _ready():
	SPEED = 150
	TYPE = 'ENEMY'
	health = 3

func setNormalTexture():
	$sprite.set_texture(normal_texture)
	remove_child(texture_timer)
	texture_timer = null

func setDamagedTexture():
	$sprite.set_texture(damaged_texture)
	texture_timer = Timer.new()
	texture_timer.connect('timeout', self, 'setNormalTexture')
	texture_timer.set_wait_time(0.5)
	add_child(texture_timer)
	texture_timer.start()

func healthLoop():
	if health <= 0:
		globals.spider_count -= 1
		queue_free()

func chasePlayer():
	var motion
	var player = get_node('../player')
	if hitstun == 0:
		motion = (player.position - position).normalized() * SPEED
	else:
		motion = knock_dir.normalized() * SPEED * 1.5
	move_and_slide(motion)

func wander_loop():
	var player = get_node('../player')
	var dist = getDistanceToPlayer()
	if dist != -1 and dist < 150:
		chasePlayer()
	else:
		movementLoop()
	if movementtimer > 0:
		movementtimer -= 1
	if movementtimer == 0 or is_on_wall():
		movement_dir = directions.get_random_direction()
		movementtimer = MOVEMENT_TIME

func _physics_process(delta):
	damageLoop(['WEAPON', 'PLAYER'])
	healthLoop()
	wander_loop()
