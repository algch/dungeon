extends "res://engine/entity.gd"

var spider_class = load("res://enemies/spider/spider.tscn")
var nest_texture = preload("res://enemies/incubator/animations/nest.png")
var incubator_texture = preload("res://enemies/incubator/animations/incubator.png")

onready var spawn_dir = directions.get_random_direction()
var should_wander = true

const SPAWN_TIME = 100
var spawntimer = SPAWN_TIME

const MOVEMENT_TIME = 50
var movementtimer = 0

var DAMAGE = 1

func _ready():
	SPEED = 250
	# TODO figure out naming for types
	TYPE = 'ENEMY'
	health = 5

func healthLoop():
	if health <= 0:
		globals.spider_count -= 1
		queue_free()

func escapeFromPlayer():
	var motion
	var player = get_node('../player')
	if hitstun == 0:
		motion = (position - player.position).normalized() * SPEED
	else:
		motion = knock_dir.normalized() * SPEED * 1.5
	move_and_slide(motion)

func wander_loop():
	$sprite.set_texture(incubator_texture)
	var dist = getDistanceToPlayer()
	if dist != -1 and dist < 200:
		escapeFromPlayer()
	else:
		movementLoop()
	if movementtimer > 0:
		movementtimer -= 1
	if movementtimer == 0 or is_on_wall():
		movement_dir = directions.get_random_direction()
		movementtimer = MOVEMENT_TIME

func spawn_loop():
	$sprite.set_texture(nest_texture)
	if spawntimer > 0:
		spawntimer -= 1
	if spawntimer == 0:
		spawn_dir = directions.get_random_direction() * 32
		if not test_move(transform, spawn_dir):
			var new_spider = spider_class.instance()
			new_spider.position = position +  spawn_dir
			get_parent().add_child(new_spider)
			spawntimer = SPAWN_TIME

			globals.spider_count += 1
			should_wander = true

func _physics_process(delta):
	damageLoop(['WEAPON', 'PLAYER'])
	healthLoop()
	if should_wander or hitstun > 0:
		wander_loop()
		if globals.spider_count < 25:
			should_wander = randi() % 100 != 0
	else:
		spawn_loop()
