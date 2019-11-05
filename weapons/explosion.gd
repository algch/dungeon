extends Area2D

var TYPE = 'EXPLOSION'
var DAMAGE = 5

func onExplosionFinished():
	queue_free()

func _physics_process(delta):
	for area in get_overlapping_areas():
		var body = area.get_parent()
		if body.get('TYPE') in ['ENEMY', 'PLAYER']:
			body.takeDamage(DAMAGE, body)
