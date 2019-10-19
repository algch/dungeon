extends "res://engine/entity.gd"

onready var on_wall_texture = preload("res://player/on_wall.png")
onready var normal_texture = preload("res://player/player.png")

func _ready():
	SPEED = 200
	TYPE = 'PLAYER'

func _physics_process(delta):
	controls_loop()
	movement_loop()
	damage_loop()
