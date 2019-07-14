extends Sprite

var speed = 400
var velocity

func _process(delta):
	position += velocity * delta
	pass

# the bullet hitted the player
func _on_Hazard_body_entered(body):
	if body.is_in_group("player"):
		queue_free()

func _on_Timer_timeout():
	queue_free()
