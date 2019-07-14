extends "res://multiuse_resources/StateMachine.gd"

signal health_changed
signal died

var health_max = 1
var health = health_max
var after_hit_invulner_time = 0
var after_hit_invulner_timer = 0

func _set_health_variables(h_m = 1, a_h_i = 0):
	health_max = h_m
	health = health_max
	after_hit_invulner_time = a_h_i

func _ready():
	add_state("vulnerable")
	add_state("invulnerable")
	add_state("dead")
	call_deferred("set_state", states.vulnerable)
	set_process(false)

func _process(delta):
	after_hit_invulner_timer -= 1
	
	if after_hit_invulner_timer <= 0:
		set_process(false)

func take_damage(damage):
	if states.vulnerable != state:
		return

	health -= damage
	if health <= 0:
		health = 0
		set_state(states.dead)
		if get_parent().is_in_group("enemy"):
			##########################
			#dead enemt animation here
			get_parent().queue_free()
			return
		else:
			emit_signal("died")
			return

	emit_signal("health_changed")
	if after_hit_invulner_time != 0:
		set_process(true)
		set_state(states.invulnerable)
		after_hit_invulner_timer = after_hit_invulner_time
		get_node("anim_damage").play("invulnerable")
	
func visuals_visibility(T_or_F):
	get_parent().get_node("visuals").visible = T_or_F
	pass

func _on_anim_damage_animation_finished(anim_name):
	if after_hit_invulner_timer <= 0:
		set_state(states.vulnerable)
	else:
		get_node("anim_damage").play("invulnerable")
