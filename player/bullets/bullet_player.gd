extends Area2D

var damage = 1
var velocity

func _ready():
	$anim.play("anim")

func _process(delta):
	position += velocity * delta
	pass

func _on_Timer_timeout():
	queue_free()

func _on_bullet_player_body_entered(body):
	if body.is_in_group("enemy"):
		var health_system = body.get_node("health_system")
		if health_system.state == health_system.states.vulnerable:
			health_system.take_damage(damage)
			Globals.screen_shake(0.2, 15, 8 * damage, 1)
			
			if !health_system.get_is_alive():
				var points = load("res://objects/Points.tscn").instance()
				points.position = body.position
				get_parent().add_child(points)
			
			call_deferred("free")
