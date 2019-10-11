extends "res://engine/entity.gd"

var cloud_class = load("res://enemies/cloud.tscn")
const SPAWN_TIME = 100
var spawntimer = SPAWN_TIME
onready var spawn_dir = directions.get_random_direction()

func _ready():
	SPEED = 40

func _physics_process(delta):
	if spawntimer > 0:
		spawntimer -= 1
	if spawntimer == 0:
		# SPAWN CLOUD AT 
		spawn_dir = directions.get_random_direction() * 64
		if not test_move(transform, spawn_dir):
			print(spawn_dir)
			var new_cloud = cloud_class.instance()
			new_cloud.position = position + spawn_dir
			get_node("../").add_child(new_cloud)
			spawntimer = SPAWN_TIME
	