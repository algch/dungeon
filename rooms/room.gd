extends RigidBody2D

var size

func makeRoom(_pos, _size):
	position = _pos
	size = _size
	var shape = RectangleShape2D.new()
	shape.custom_solver_bias = 0.75
	shape.extents = size / 2
	$CollisionShape2D.set_shape(shape)
