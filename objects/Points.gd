extends Area2D

var points = 1

func _on_Points_body_entered(body):
	if body.is_in_group("player") and Globals.in_alter_dimension == true:
		touched()

func touched():
	get_parent().actualize_score(points)
	Globals.screen_shake(0.2,15, 8 * points)
	queue_free()
		
