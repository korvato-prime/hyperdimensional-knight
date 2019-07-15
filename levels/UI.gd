extends CanvasLayer

onready var player_HP = get_parent().get_node("player/health_system")
var stamina_recharge_counter = 8

signal can_punch_again

func _process(delta):
	$ProgressBar/Label.text = "%s/%s" % [str(player_HP.health), str(player_HP.health_max)] 

func _on_player_bullet_reduce():
	$BulletChargeBar.value -= 1
	pass # Replace with function body.

func _on_player_stamina_reduce():
	$StaminaBar.value -= 30
	pass # Replace with function body.

func _on_player_hit():
	$ProgressBar.value -= 1
	pass # Replace with function body.

func _on_StaminaCooldown_timeout():
	$StaminaRecharge.start()
	pass # Replace with function body.

func _on_StaminaBar_value_changed(value):
	if value < 100:
		$StaminaCooldown.start()
	if value > 30:
		emit_signal("can_punch_again")
	pass # Replace with function body.

func _on_StaminaRecharge_timeout():
	recharge_stamina()
	pass # Replace with function body.

func recharge_stamina():
	if $StaminaBar.value < 100:
		$StaminaBar.value += 10
		$StaminaRecharge.start()		
