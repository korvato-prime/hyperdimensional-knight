extends Node2D

var score = 0
var highscore = Globals.highscore

func _ready():
	#$AlterDimension.hide()
	$AlterDimension.show()
	$solids.modulate.a = 0.15
	_on_dimension_swap()
	
	$AlterDimension.set_collision_layer_bit(1,0)
	$player.connect("dimension_swap", self, "_on_dimension_swap")

func _on_dimension_swap():
	#if $solids.visible:
	if $solids.modulate.a == 1:
		#$solids.hide()
		#$AlterDimension.show()
		
		$solids.modulate.a = 0.25
		$AlterDimension.modulate.a = 1
		
		$solids.z_index = 100
		$AlterDimension.z_index = -100
		
		$solids.set_collision_layer_bit(1,0)
		$AlterDimension.set_collision_layer_bit(1,1)
		
		Globals.in_alter_dimension = false
	else:
		#$AlterDimension.hide()
		#$solids.show()
		
		$solids.modulate.a = 1
		$AlterDimension.modulate.a = 0.25
		
		$solids.z_index = -100
		$AlterDimension.z_index = 100
		
		$AlterDimension.set_collision_layer_bit(1,0)
		$solids.set_collision_layer_bit(1,1)
		
		Globals.in_alter_dimension = true
	
	for points in get_tree().get_nodes_in_group("points"):
		if ($player.position - points.position).length() < 40:
			actualize_score(points.points)
			Globals.screen_shake(0.2,15, 8 * points.points)
			points.touched()
	
func actualize_score(points):
	score += points
	get_node("UI/Score").text = str(score)


