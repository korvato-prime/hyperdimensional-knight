extends KinematicBody2D

# flying details
var is_flying = true
var is_facing_right = false
var fly_speed = 5
var amplitude = 10
var theta = 0

# walking details
var gravity_fall = 6200
var gravity_jump = 4800
var gravity = gravity_fall
var velocity_fall_max = 2000
const UP = Vector2(0, -1)
const SLOPE_STOP = 400
var velocity = Vector2()
var move_speed = 100
var direction
var is_grounded
const COYOTE_TIME = 4
var coyote_time_timer = 0

# signals
signal hit

# onready variables
onready var raycasts_down = $raycasts_down
onready var health_system = $health_system

var health_multiplier

func _ready():
	
	if (is_facing_right):
		direction = 1
	else:
		direction = -1
		
	is_grounded = false
	enable_raycast(direction)
	
	for raycast in raycasts_down.get_children():
		raycast.add_exception(self)
	
	# enemy health
	var health = 2 * health_multiplier
	health_system._set_health_variables(health, 0)

func _every_step(delta):
	if position.x < -10 || position.x > 1930 || position.y < -10 || position.y > 1090:
		queue_free()
	elif (is_flying):
		fly()
	else:
		_horizontal_move()
		is_grounded = _check_is_grounded()
		velocity = move_and_slide_with_snap(velocity, UP)
		_apply_gravity(delta)
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

func _apply_gravity(delta):
	if velocity.y >= 0:
		gravity = gravity_fall
	else:
		gravity = gravity_jump
	if velocity.y > velocity_fall_max:
		velocity.y = velocity_fall_max
	
	velocity.y += gravity * delta

func _horizontal_move():
	
	if (is_on_ledge() || is_on_wall()):
		direction *= -1
		enable_raycast(direction)
		
	velocity.x = move_speed * direction
	velocity = move_and_slide(velocity, UP)
	if direction != 0:
		$visuals.scale.x = direction

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

func enable_raycast(direction):
	if (direction == 1):
		$raycasts_down/raycast_right.enabled = true
		$raycasts_down/raycast_left.enabled = false
	else:
		$raycasts_down/raycast_right.enabled = false
		$raycasts_down/raycast_left.enabled = true