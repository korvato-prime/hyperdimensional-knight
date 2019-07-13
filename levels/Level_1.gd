extends Node2D

func _ready():
	$AlterDimension.hide()
	$AlterDimension.set_collision_layer_bit(1,0)
	$player.connect("dimension_swap", self, "_on_dimension_swap")

func _on_dimension_swap():
	if $solids.visible:
		$solids.hide()
		$solids.set_collision_layer_bit(1,0)
		$AlterDimension.show()
		$AlterDimension.set_collision_layer_bit(1,1)
	else:
		$AlterDimension.hide()
		$AlterDimension.set_collision_layer_bit(1,0)
		$solids.show()
		$solids.set_collision_layer_bit(1,1)

func _on_HazardArea_body_entered(body):
	if body is Player:
		Globals.player_current_life -=1
	pass # Replace with function body.
