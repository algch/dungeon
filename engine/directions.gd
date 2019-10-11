extends Node

const center = Vector2(0, 0)
const left = Vector2(-1, 0)
const right = Vector2(1, 0)
const up = Vector2(0, -1)
const down = Vector2(0, 1)

func get_random_direction():
    var direction = randi() % 4
    match direction:
        0:
            return left
        1:
            return right
        2:
            return up
        3:
            return down