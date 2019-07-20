extends KinematicBody2D

const UP = Vector2(0, -1)
const SLOPE_STOP = 400
var velocity = Vector2()
var move_speed = 100
var direction

signal dimension_swap
signal hit

#saltos
var gravity_fall = 4200
var gravity_jump = 3000
var gravity = gravity_fall
var jump_velocity = -1200
var velocity_fall_max = 1500
const COYOTE_TIME = 4
const PRE_JUMP_PRESSED = 4
var coyote_time_timer = 0
var pre_jump_timer = 0
var DROP_THRU_BIT = 10
var jump_timer = 75
var current_jump_timer = 0

# action
var action_coldown_time = 20
var action_coldown_timer = 0

onready var raycasts_down = $raycasts_down
onready var health_system = $health_system

var is_grounded
var health_multiplier

func _ready():
	
	current_jump_timer = jump_timer
	move_speed = 100#round(rand_range(100, 200))
	direction = get_random_direction()
	enable_raycast(direction)
	
	for raycast in raycasts_down.get_children():
		raycast.add_exception(self)
	
	# enemy health
	var health = 1 * health_multiplier
	health_system._set_health_variables(health, 0)

func _apply_gravity(delta):
	if velocity.y >= 0:
		gravity = gravity_fall
	else:
		gravity = gravity_jump
	if velocity.y > velocity_fall_max:
		velocity.y = velocity_fall_max
	
	velocity.y += gravity * delta
	
	if $RayCast2D.is_colliding():
		var col = $RayCast2D.get_collider()
		print(col)
		# var n = F_LEG.get_collider()
		if col.is_in_group("Tiles"):
    		print("it's in the group!")

		self.queue_free()
		
	if $RayCast2D2.is_colliding():
		var col = $RayCast2D2.get_collider()
		print(col)
		# var n = F_LEG.get_collider()
		if col.is_in_group("Tiles"):
    		print("it's in the group!")

		self.queue_free()
		
	if $RayCast2D3.is_colliding():
		var col = $RayCast2D3.get_collider()
		print(col)
		# var n = F_LEG.get_collider()
		if col.is_in_group("Tiles"):
    		print("it's in the group!")

		self.queue_free()
	
	if $RayCast2D4.is_colliding():
		var col = $RayCast2D4.get_collider()
		print(col)
		# var n = F_LEG.get_collider()
		if col.is_in_group("Tiles"):
    		print("it's in the group!")

		self.queue_free()

func _every_step():
	if action_coldown_timer > 0:
		action_coldown_timer -= 1
	
	if pre_jump_timer > 0:
		pre_jump_timer -= 1
	elif is_grounded && current_jump_timer < 0:
		jump()
	else:
		current_jump_timer -= 1
		
	is_grounded = _check_is_grounded()
	
	velocity = move_and_slide_with_snap(velocity, UP)
		

func attacking():
	
	if action_coldown_timer == 0:
		# intert 
		# dimensional
		# mechanic
		# here
		action_coldown_time = action_coldown_timer
		pass

func _horizontal_move():
	#prints("isgrounded", is_grounded)
	if (is_on_wall() && is_grounded):
		direction *= -1
		enable_raycast(direction)
		
	velocity.x = move_speed * direction
	velocity = move_and_slide(velocity, UP)
	
	if direction != 0:
		$visuals.scale.x = direction

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

func is_on_ledge():
	
	var is_on_ledge = true
	if (is_grounded):
		if ($raycasts_down/raycast_right.enabled):
			if ($raycasts_down/raycast_right.is_colliding()):
				is_on_ledge = false
				
		if ($raycasts_down/raycast_left.enabled):
			if ($raycasts_down/raycast_left.is_colliding()):
				is_on_ledge = false
	else:
		is_on_ledge = false

	return is_on_ledge
		
func can_jump():
	return (coyote_time_timer > 0 and pre_jump_timer > 0)

func jump():
	coyote_time_timer = 0
	pre_jump_timer = 0
	current_jump_timer = jump_timer
	velocity.y = jump_velocity

func get_random_direction():
	randomize()
	if (randi() % 2) == 1:
		return 1 # right
	return -1 # left

func enable_raycast(direction):
	if (direction == 1):
		$raycasts_down/raycast_right.enabled = true
		$raycasts_down/raycast_left.enabled = false
	else:
		$raycasts_down/raycast_right.enabled = false
		$raycasts_down/raycast_left.enabled = true