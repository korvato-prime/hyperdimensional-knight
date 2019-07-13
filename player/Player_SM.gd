extends "res://multiuse_resources/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("hitted")
	add_state("dead")
	call_deferred("set_state", states.idle)

func _get_input():
	
	parent._horizontal_move()
	
	if Input.is_action_just_pressed("cancel"):
		parent.attacking()
		
	if Input.is_action_just_pressed("switch"):
		parent.change_dimension()
	
	if Input.is_action_just_pressed("confirm"):
		if Input.is_action_pressed("down"):
			parent.set_collision_mask_bit(parent.DROP_THRU_BIT, false)
		else:
			parent.pre_jump_timer = parent.PRE_JUMP_PRESSED
	
	if states.jump == state:
		#frenar el salto si suelto jump_button
		if !Input.is_action_pressed("confirm"):
			if parent.velocity.y < 0:
				parent.velocity.y /= 2
	

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
				else:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
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
			parent.get_node("anim_player").play("idle")
		states.run:
			parent.get_node("anim_player").play("run2")
		states.jump:
			parent.get_node("anim_player").play("jump")
		states.fall:
			parent.get_node("anim_player").play("fall")
		states.hitted:
			parent.get_node("anim_player").play("jump")
			parent.jump()

func _exit_state(old_state, new_state):
	pass

func _on_health_system_died():
	get_tree().reload_current_scene()
	
func _on_health_system_health_changed():
	var h_s = get_parent().get_node("health_system")
	h_s.set_state(h_s.states.invulnerable)
	set_state(states.hitted)

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	var h_s = get_parent().get_node("health_system")
	h_s.take_damage(1000)
