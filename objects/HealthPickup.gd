extends Area2D

func _ready():
	$anim.play("anim")

func _on_HealthPickup_body_entered(body):
	if body.is_in_group("player")  and Globals.in_alter_dimension == true:
		touched()

func touched():
	var player = get_tree().get_nodes_in_group("player")[0]
	if player.get_node("health_system").health < player.get_node("health_system").health_max:
		player.get_node("health_system").health += 1
		Globals.screen_shake(0.2, 15, 16)
		queue_free()
