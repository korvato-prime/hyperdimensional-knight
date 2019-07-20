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
var gravity_fall = 6200				##############
var gravity_jump = 4800				##############
var gravity = gravity_fall
var jump_velocity = -1625			##############
var second_jump = 0					##############
var can_second_jump = 0
var velocity_fall_max = 2000
const COYOTE_TIME = 4
const PRE_JUMP_PRESSED = 4
var coyote_time_timer = 0
var pre_jump_timer = 0
var DROP_THRU_BIT = 10

# action
var stamina = 100
var stamina_max = 100
var stamina_recovery = 0.1
var punch_coldown_time = 20			##############
var punch_coldown_timer = 0
var punch_damage = 2				##############
var can_punch = true

var points_obj = load("res://objects/Points.tscn")
var bullet_obj = load("res://player/bullets/bullet_player.tscn")
var bullets_per_shoot = 1			##############
var gun_coldown_time = 10			##############
var gun_coldown_timer = 0
var gun_damage = 1					##############
var can_shoot = true
var bullet_speed = 850				##############
var bullet_trajectory_randomness = 0.02 # percent
var ammo = 5
var ammo_max = 10

onready var raycasts_down = $raycasts_down

var is_grounded

func _ready():
	for raycast in raycasts_down.get_children():
		raycast.add_exception(self)
	
	$health_system._set_health_variables(4,40)

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

	if stamina < stamina_max:
		stamina += stamina_recovery

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
		stamina -= 30
		get_node("anim_attack").play("punch")
		punch_coldown_time = punch_coldown_timer
		emit_signal("stamina_reduce")
		move_and_slide_with_snap(Vector2(500 * get_node("visuals").scale.x, 0), UP)

func shooting():
	if gun_coldown_timer == 0:
		ammo -= 1
		get_node("anim_attack").play("shoot")
		gun_coldown_timer = gun_coldown_time
		emit_signal("bullet_reduce")
		Globals.screen_shake(0.1, 15, 8 * punch_damage, 1)
		
		var player_direction = Vector2(get_node("visuals").scale.x, 0)
		for i in range(bullets_per_shoot):
			var bullet = bullet_obj.instance()
			# some noise to the position if various bullets are shooted simultaniusly
			var noise = Vector2()
			if bullets_per_shoot > 1:
				noise.y = rand_range(-10,-10)
			bullet.position = position + noise
			bullet.position.x += 15 * player_direction.x
			
			get_parent().add_child(bullet)
			# add some noise to the bullet´s trajectory
			var noise_2 = Vector2(rand_range(-bullet_trajectory_randomness,bullet_trajectory_randomness), rand_range(-bullet_trajectory_randomness,bullet_trajectory_randomness))
			player_direction = (player_direction + bullets_per_shoot * noise_2).normalized()
			bullet.velocity = player_direction* bullet_speed 
			bullet.damage = gun_damage
		
		move_and_slide_with_snap(-400 * player_direction, UP)
		# evitate punch collider error
		get_node("visuals/fist_temporal").visible = false
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
			can_second_jump = second_jump
			return true
	### en aire
	if coyote_time_timer > 0:
			coyote_time_timer -= 1
	return false

func can_jump():
	return ( (coyote_time_timer > 0 and pre_jump_timer > 0) or (can_second_jump > 0 and Input.is_action_just_pressed("jump")))

func jump():
	if coyote_time_timer > 0 and pre_jump_timer > 0:
		coyote_time_timer = 0
		pre_jump_timer = 0
	else:
		can_second_jump -= 1 
	velocity.y = jump_velocity

func _on_punch_hitbox_body_entered(body):
	apply_punch_damage(body)
func _on_punch_hitbox_area_entered(area):
	apply_punch_damage(area)
func apply_punch_damage(enemy):
	if enemy.is_in_group("enemy"):
		
		var health_system = enemy.get_node("health_system")
		
		health_system.take_damage(punch_damage)
		Globals.screen_shake(0.2, 15, 16 * punch_damage, 1)
		
		if !health_system.get_is_alive():
			var points = points_obj.instance()
			points.position = enemy.position
			get_parent().add_child(points)
