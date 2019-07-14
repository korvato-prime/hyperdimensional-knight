extends KinematicBody2D

const UP = Vector2(0, -1)
var player_is_in_scope = false

var bullet_obj = load("res://enemies/gunner/objects/Bullet/Bullet.tscn")

signal hit

# action
var action_coldown_time = 50
var action_coldown_timer = 50

onready var health_system = $health_system

var is_grounded

func _ready():
	health_system._set_health_variables(3, 0)

func _every_step():
	if action_coldown_timer < 0 && player_is_in_scope:
		attack()
		action_coldown_timer = action_coldown_time
	else:
		action_coldown_timer -= 1
	pass

func attack():
	
	var bullet_instance = bullet_obj.instance()
	bullet_instance.position = self.position
	self.get_parent().add_child(bullet_instance)
	
	pass

func _on_health_system_health_changed():
	$anim_damage.play("damaged")
	# change health visuals

func vulnerability(boole):
	if boole:
		$health_system.set_state($health_system.states.vulnerable)
	else:
		$health_system.set_state($health_system.states.invulnerable)

func _on_scope_body_entered(body):
	if (body.is_in_group("player")):
		player_is_in_scope = true
		print("entered")
	pass # Replace with function body.

func _on_scope_body_exited(body):
	if (body.is_in_group("player")):
		player_is_in_scope = false
		print("exited")
	pass # Replace with function body.
