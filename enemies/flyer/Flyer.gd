extends KinematicBody2D

signal hit
onready var health_system = $health_system

# flying details
var is_flying = true
var is_facing_right = false
var fly_speed = 5
var amplitude = 10
var theta = 0
var health_multiplier

func _ready():
	# enemy health
	var health = 2 * health_multiplier
	health_system._set_health_variables(health, 0)

func _every_step():
	if position.x < -10 || position.x > 1930 || position.y < -10 || position.y > 1090:
		queue_free()
	else:
		fly()
	pass

func fly():
	if (is_facing_right):
		self.position.x += round(fly_speed)
	else:
		self.position.x -= round(fly_speed)
	self.position.y += round(sin(theta/(2 * PI)) * amplitude)
	theta += 1
	if (theta > 360): theta = 0
	pass

