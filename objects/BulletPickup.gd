extends Area2D

func _ready():
	$anim.play("anim")

func _on_BulletPickup_body_entered(body):
	if body.is_in_group("player") and Globals.in_alter_dimension == true:
		touched()

func touched():
	var player = get_tree().get_nodes_in_group("player")[0]
	if player.ammo < player.ammo_max:
		player.ammo += 1
	Globals.screen_shake(0.2, 15, 16)
	queue_free()
