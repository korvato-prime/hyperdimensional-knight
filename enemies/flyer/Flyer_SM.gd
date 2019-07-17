extends "res://multiuse_resources/StateMachine.gd"

var reverted = false

func _ready():
	add_state("flying")
	add_state("attack")
	add_state("hitted")
	add_state("dead")
	call_deferred("set_state", states.flying)

func _get_input():
	pass

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

func _get_transition(delta):
	match state:
		states.flying: return states.flying
		states.attack: return states.hitted
		states.hitted: return states.hitted
		states.dead: return states.dead
	return null
		
func _enter_state(new_state, old_state):
	match new_state:
		states.flying:
			#parent.get_node("anim_enemy").play("flying")
			pass
		states.attack:
			#parent.get_node("anim_enemy").play("attack")
			pass
		states.hitted:
			#parent.get_node("anim_enemy").play("hitted")
			pass
		states.dead:
			#parent.get_node("anim_enemy").play("dead")
			pass
			
func _exit_state(old_state, new_state):
	pass
	
func _on_health_system_health_changed():
	set_state(states.hitted)
