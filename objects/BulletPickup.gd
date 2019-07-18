extends Area2D

func _ready():
	$anim.play("anim")

func _on_BulletPickup_body_entered(body):
	if body.is_in_group("player") and Globals.in_alter_dimension == true:
		if body.ammo < body.ammo_max:
			body.get_node("health_system").ammo += 1
			Globals.screen_shake(0.2, 15, 16)
			queue_free()
