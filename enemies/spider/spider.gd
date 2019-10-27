extends "res://engine/entity.gd"

var spider_class = load("res://enemies/spider/spider.tscn")
var nest_texture = preload("res://enemies/spider/animations/nest.png")
var spider_texture = preload("res://enemies/spider/animations/spider.png")
onready var spawn_dir = directions.get_random_direction()
var should_wander = true

const SPAWN_TIME = 100
var spawntimer = SPAWN_TIME

const MOVEMENT_TIME = 50
var movementtimer = 0

var DAMAGE = 1

func _ready():
	SPEED = 150
	TYPE = 'ENEMY'
	health = 3

func healthLoop():
	if health <= 0:
		globals.cloud_count -= 1
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
	$sprite.set_texture(spider_texture)
	var player = get_node('../player')
	var dist = (player.position - position).length()
	if dist < 150:
		chasePlayer()
	else:
		movement_loop()
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

			globals.cloud_count += 1
			should_wander = true

func _physics_process(delta):
	damage_loop(['WEAPON'], ['PLAYER'])
	healthLoop()
	if should_wander or hitstun > 0:
		wander_loop()
		if globals.cloud_count < 25:
			should_wander = randi() % 100 != 0
	else:
		spawn_loop()
	