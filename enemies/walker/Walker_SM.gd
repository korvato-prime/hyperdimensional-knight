extends "res://multiuse_resources/StateMachine.gd"

var reverted = false

var hit = load("res://sounds/Enemy/Enemy hit.wav")
var death = load("res://sounds/Enemy/enemy death.wav")

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("hitted")
	add_state("dead")
	call_deferred("set_state", states.run)

func _get_input():
	parent._horizontal_move()

func _state_logic(delta):
	if Input.is_action_just_pressed("select"):
		if get_tree().paused:
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)
		return
	
	if not get_tree().paused:
		_get_input()
		parent._every_step()
		if parent.can_jump():
			parent.jump()
		parent._apply_gravity(delta)

func _get_transition(delta):
	match state:
		states.idle:
			if ! parent._check_is_grounded():
				if parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if ! parent._check_is_grounded():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 5:
					return states.fall
		states.jump:
			if parent._check_is_grounded():
				if parent.velocity.x != 0:
					return states.run
				else:
					return states.idle
			elif parent.velocity.y > 0:
				return states.fall
		states.fall:
			if parent._check_is_grounded():
				if parent.velocity.x != 0:
					return states.run
				else:
					return states.idle
			elif parent.velocity.y < 0:
				return states.jump
		states.hitted:
			if parent._check_is_grounded():
				if parent.velocity.x != 0:
					return states.run
				else:
					return states.idle
			elif parent.velocity.y > 0:
				return states.fall
	return null
		
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			#parent.get_node("anim_enemy").play("idle")
			pass
		states.run:
			parent.get_node("anim_enemy").play("run")
			pass
		states.jump:
			#parent.get_node("anim_enemy").play("jump")
			pass
		states.fall:
			parent.get_node("anim_enemy").play("fall")
			pass
		states.hitted:
			#parent.get_node("anim_enemy").play("jump")
			parent.jump()
			parent.emit_signal("hit")
			

func _exit_state(old_state, new_state):
	pass
	
func _on_health_system_health_changed():
	set_state(states.hitted)
