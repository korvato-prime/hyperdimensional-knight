extends KinematicBody2D

signal hit
onready var health_system = $health_system

# flying details
var is_flying = true
var is_facing_right = false
var fly_speed = 5
var amplitude = 10
var theta = 0

func _ready():
	health_system._set_health_variables(3, 0)

func _every_step():
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

func _on_health_system_health_changed():
	$anim_damage.play("damaged")
	# change health visuals

func vulnerability(boole):
	if boole:
		$health_system.set_state($health_system.states.vulnerable)
	else:
		$health_system.set_state($health_system.states.invulnerable)