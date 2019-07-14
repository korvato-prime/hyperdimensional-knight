extends KinematicBody2D

const UP = Vector2(0, -1)
var player_object = null

var bullet_obj = load("res://enemies/gunner/objects/Bullet/Bullet.tscn")

signal hit

# action
var action_coldown_time = 100
var action_coldown_timer = 0

onready var health_system = $health_system

var is_grounded

func _ready():
	health_system._set_health_variables(3, 0)

func _every_step():
	if action_coldown_timer < 0 && player_object != null:
		attack()
		action_coldown_timer = action_coldown_time
	else:
		action_coldown_timer -= 1
	pass

func attack():
	
	var bullet = bullet_obj.instance()
	bullet.position = self.position
#	bullet.rotation = (player_object.global_position - self.global_position).angle()
	self.get_parent().add_child(bullet)
	var direction = (player_object.global_position - self.global_position).normalized()
	bullet.velocity = direction * bullet.speed
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
		player_object = body
		print("entered")
	pass # Replace with function body.

func _on_scope_body_exited(body):
	if (body.is_in_group("player")):
		player_object = null
		print("exited")
	pass # Replace with function body.
