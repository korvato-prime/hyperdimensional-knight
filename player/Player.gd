extends KinematicBody2D

const UP = Vector2(0, -1)
const SLOPE_STOP = 400
var velocity = Vector2()
var move_speed = 500

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
var DROP_THRU_BIT = 0

# action
var action_coldown_time = 20
var action_coldown_timer = 0
var actual_dimension = 0

# attack
var punch_coldown_time = 20
var gun_coldown_time = 20
var attack_coldown_timer = 2
var weapon = "punch"

onready var raycasts_down = $raycasts_down

var is_grounded

func _ready():
	
	for raycast in raycasts_down.get_children():
		raycast.add_exception(self)
	
	$health_system._set_health_variables(3, 0)
	
	change_dimension()

func _apply_gravity(delta):
	if velocity.y >= 0:
		gravity = gravity_fall
	else:
		gravity = gravity_jump
	if velocity.y > velocity_fall_max:
		velocity.y = velocity_fall_max
	
	velocity.y += gravity * delta

func _every_step():
	if action_coldown_timer > 0:
		action_coldown_timer -= 1
	
	if attack_coldown_timer > 0:
		attack_coldown_timer -= 1
	
	if pre_jump_timer > 0:
		pre_jump_timer -= 1
	
	if !Input.is_action_pressed("ui_down"):
		set_collision_mask_bit(DROP_THRU_BIT, true)
	
	is_grounded = _check_is_grounded()
	
	velocity = move_and_slide_with_snap(velocity, UP)
	
	### temporal
	get_node("CanvasLayer/weapon").text = "weapon: " + weapon
	get_node("CanvasLayer/dimention").text = "dimention: " + str(actual_dimension)

func attacking():
	if attack_coldown_timer == 0:
		match (weapon):
			"punch":
				print("punching")
				print("trust me dude ;)")
				attack_coldown_timer = punch_coldown_time
			"gun":
				print("shooting")
				print("trust me dude ;)")
				attack_coldown_timer = gun_coldown_time
	pass

func change_dimension():
	if action_coldown_timer == 0:
		if actual_dimension == 1:
			actual_dimension = 2
			get_node("visuals").modulate = Color(0,1,0)
		else:
			actual_dimension = 1
			get_node("visuals").modulate = Color(1,0,0)
		
		set_collision_layer_bit(actual_dimension, true)
		set_collision_layer_bit(3 - actual_dimension, false)
		set_collision_mask_bit(actual_dimension, true)
		set_collision_mask_bit(3 - actual_dimension, false)
		action_coldown_timer = action_coldown_time


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

func _on_health_system_health_changed():
	$anim_damage.play("damaged")
	# change health visuals

func vulnerability(boole):
	if boole:
		$health_system.set_state($health_system.states.vulnerable)
	else:
		$health_system.set_state($health_system.states.invulnerable)
