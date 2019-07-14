extends Area2D

var damage = 1
var speed = 400
var velocity

func _process(delta):
	position += velocity * delta
	print(position)
	pass