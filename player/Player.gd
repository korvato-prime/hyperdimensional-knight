extends KinematicBody2D
class_name Player

const UP = Vector2(0, -1)
const SLOPE_STOP = 400
var velocity = Vector2()
var move_speed = 500

signal dimension_swap
signal hit
signal stamina_reduce
signal bullet_reduce

#saltos
var gravity_fall = 6200
var gravity_jump = 4800
var gravity = gravity_fall
var jump_velocity = -1625
var velocity_fall_max = 2000
const COYOTE_TIME = 4
const PRE_JUMP_PRESSED = 4
var coyote_time_timer = 0
var pre_jump_timer = 0
var DROP_THRU_BIT = 10

# action
var punch_coldown_time = 20
var punch_coldown_timer = 0
var punch_damage = 1
var can_punch = true

var gun_coldown_time = 20
var gun_coldown_timer = 0
var gun_damage = 1
var can_shoot = true

onready var raycasts_down = $raycasts_down

var is_grounded

func _ready():
	for raycast in raycasts_down.get_children():
		raycast.add_exception(self)
	
	$health_system._set_health_variables(4)

func _apply_gravity(delta):
	if velocity.y >= 0:
		gravity = gravity_fall
	else:
		gravity = gravity_jump
	if velocity.y > velocity_fall_max:
		velocity.y = velocity_fall_max
	
	velocity.y += gravity * delta

func _every_step():
	if punch_coldown_timer > 0:
		punch_coldown_timer -= 1
	
	if gun_coldown_timer > 0:
		gun_coldown_timer -= 1
	
	if pre_jump_timer > 0:
		pre_jump_timer -= 1
	
	if !Input.is_action_pressed("ui_down"):
		set_collision_mask_bit(DROP_THRU_BIT, true)
	
	is_grounded = _check_is_grounded()
	
	velocity = move_and_slide_with_snap(velocity, UP)

func punching():
	if punch_coldown_timer == 0:
		get_node("anim_attack").play("punch")
		punch_coldown_time = punch_coldown_timer
		emit_signal("stamina_reduce")

func shooting():
	if gun_coldown_timer == 0:
		get_node("anim_attack").play("shoot")
		gun_coldown_time = gun_coldown_timer
		emit_signal("bullet_reduce")
		
		# evitate punch collider error
		get_node("visuals/punch_hitbox/collision").disabled = true


func _horizontal_move():
	var move_direction
	move_direction = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.x = lerp(velocity.x, move_direction * move_speed, get_h_weight())

	if move_direction != 0:
		$visuals.scale.x = move_direction

func get_h_weight():
	return 0.6 if is_grounded else 0.3

func _check_is_grounded():
	for raycast in raycasts_down.get_children():
		if raycast.is_colliding():
			### en suelo
			coyote_time_timer = COYOTE_TIME
			return true
	### en aire
	if coyote_time_timer > 0:
			coyote_time_timer -= 1
	return false

func can_jump():
	return (coyote_time_timer > 0 and pre_jump_timer > 0)

func jump():
	coyote_time_timer = 0
	pre_jump_timer = 0
	velocity.y = jump_velocity

func vulnerability(boole):
	if boole:
		$health_system.set_state($health_system.states.vulnerable)
	else:
		$health_system.set_state($health_system.states.invulnerable)

func _on_punch_hitbox_body_entered(body):
	apply_punch_damage(body)
func _on_punch_hitbox_area_entered(area):
	apply_punch_damage(area)
func apply_punch_damage(enemy):
	if enemy.is_in_group("enemy"):
		print(enemy.name)
		enemy.get_node("health_system").take_damage(punch_damage)

func _on_StaminaBar_value_changed(value):
	if value == 0:
		can_punch = false
	pass # Replace with function body.

func _on_UI_can_punch_again():
	can_punch = true
	pass # Replace with function body.
