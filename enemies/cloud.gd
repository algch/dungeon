extends "res://engine/entity.gd"

var cloud_class = load("res://enemies/cloud.tscn")
onready var spawn_dir = directions.get_random_direction()
var should_wander = true

const SPAWN_TIME = 100
var spawntimer = SPAWN_TIME

const MOVEMENT_TIME = 50
var movementtimer = 0

var DAMAGE = 1

func _ready():
	SPEED = 40
	TYPE = 'ENEMY'
	health = 3

func healthLoop():
	if health <= 0:
		globals.cloud_count -= 1
		queue_free()

func wander_loop():
	movement_loop()
	if movementtimer > 0:
		movementtimer -= 1
	if movementtimer == 0 or is_on_wall():
		movement_dir = directions.get_random_direction()
		movementtimer = MOVEMENT_TIME

func spawn_loop():
	if spawntimer > 0:
		spawntimer -= 1
	if spawntimer == 0:
		# SPAWN CLOUD AT 
		spawn_dir = directions.get_random_direction() * 32
		if not test_move(transform, spawn_dir):
			var new_cloud = cloud_class.instance()
			new_cloud.position = position + spawn_dir
			get_node("../").add_child(new_cloud)
			spawntimer = SPAWN_TIME

			globals.cloud_count += 1
			should_wander = true

func _physics_process(delta):
	damage_loop(['WEAPON'])
	healthLoop()
	if should_wander or hitstun > 0:
		wander_loop()
		if globals.cloud_count < 50:
			should_wander = randi() % 20 != 0
	else:
		spawn_loop()
	