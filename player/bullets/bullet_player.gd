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
		if body.get_node("health_system").state == body.get_node("health_system").states.vulnerable:
			body.get_node("health_system").take_damage(damage)
			Globals.screen_shake(0.2, 15, 8 * damage, 1)
			queue_free()
