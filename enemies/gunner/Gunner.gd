extends KinematicBody2D

const UP = Vector2(0, -1)
var player_object = null

var bullet_obj = load("res://enemies/gunner/objects/Bullet/Bullet.tscn")

signal hit

# action
var action_coldown_time = 100
var action_coldown_timer = 0

enum bullet_type { SINGLE, DOUBLE, TRIPLE }
export var current_bullet = bullet_type.TRIPLE

onready var health_system = $health_system

var is_grounded

func _ready():
	health_system._set_health_variables(2,20)

func _every_step():
	if action_coldown_timer < 0 && player_object != null:
		match current_bullet:
			bullet_type.SINGLE: attack()
			bullet_type.DOUBLE: attack_double()
			bullet_type.TRIPLE: attack_triple()
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

func attack_double():
	
	var margin = Vector2(64, 64)
	
	var bullet = bullet_obj.instance()
	bullet.position = self.position
#	bullet.rotation = (player_object.global_position - self.global_position).angle()
	self.get_parent().add_child(bullet)
	var direction = ((player_object.global_position + margin) - self.global_position).normalized()
	bullet.velocity = direction * bullet.speed
	#print(bullet.velocity , direction, bullet.speed) 
	
	bullet = bullet_obj.instance()
	bullet.position = self.position
#	bullet.rotation = (player_object.global_position - self.global_position).angle()
	self.get_parent().add_child(bullet)
	direction = ((player_object.global_position - margin) - self.global_position).normalized()
	bullet.velocity = direction * bullet.speed
	#print(bullet.velocity , direction, bullet.speed)
	pass

func attack_triple():
	
	var margin = Vector2(128, 128)
	
	var bullet = bullet_obj.instance()
	bullet.position = self.position
#	bullet.rotation = (player_object.global_position - self.global_position).angle()
	self.get_parent().add_child(bullet)
	var direction = ((player_object.global_position + margin) - self.global_position).normalized()
	bullet.velocity = direction * bullet.speed
	#print(bullet.velocity , direction, bullet.speed) 
	
	bullet = bullet_obj.instance()
	bullet.position = self.position
#	bullet.rotation = (player_object.global_position - self.global_position).angle()
	self.get_parent().add_child(bullet)
	direction = (player_object.global_position - self.global_position).normalized()
	bullet.velocity = direction * bullet.speed
	#print(bullet.velocity , direction, bullet.speed)
	
	bullet = bullet_obj.instance()
	bullet.position = self.position
#	bullet.rotation = (player_object.global_position - self.global_position).angle()
	self.get_parent().add_child(bullet)
	direction = ((player_object.global_position - margin) - self.global_position).normalized()
	bullet.velocity = direction * bullet.speed
	#print(bullet.velocity , direction, bullet.speed)
	pass

func _on_scope_body_entered(body):
	if (body.is_in_group("player")):
		player_object = body
		#print("entered")
	pass # Replace with function body.

func _on_scope_body_exited(body):
	if (body.is_in_group("player")):
		player_object = null
		#print("exited")
	pass # Replace with function body.
