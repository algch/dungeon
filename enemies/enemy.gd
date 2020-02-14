extends "res://engine/entity.gd"

var IS_ACTIVE = false
var player

func deactivate():
    IS_ACTIVE = false

func activate():
    IS_ACTIVE = true
