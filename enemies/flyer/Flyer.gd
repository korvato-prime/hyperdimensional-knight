extends KinematicBody2D

signal hit
onready var health_system = $health_system

var facing_right = false
export var move_speed = 5
export var frequency = 20
export var magnitude = 0.5
var pos = Vector2()

func _ready():
	health_system._set_health_variables(3, 0)

func _every_step(delta):
	fly(delta)
	pass

func fly(delta):
	pos -= Vector2(1, 0) * delta * move_speed
	var sin_value = sin(delta * frequency) * magnitude
	self.position += Vector2(0, 1) * sin_value
	prints(pos, position, sin_value)
	pass

func _on_health_system_health_changed():
	$anim_damage.play("damaged")
	# change health visuals

func vulnerability(boole):
	if boole:
		$health_system.set_state($health_system.states.vulnerable)
	else:
		$health_system.set_state($health_system.states.invulnerable)