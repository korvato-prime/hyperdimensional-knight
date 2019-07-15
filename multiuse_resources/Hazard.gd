extends Area2D

export (int) var damage = 1

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("health_system").take_damage(1)
		Globals.screen_shake(0.2,15, 16 * damage)
