extends Node2D

var score = 0
var highscore = Globals.highscore

func _ready():
	randomize()
	Globals.in_alter_dimension = false
	_on_dimension_swap()
	print(Globals.in_alter_dimension)
	
	$AlterDimension.set_collision_layer_bit(1,0)
	$player.connect("dimension_swap", self, "_on_dimension_swap")
	
	$CrystalLayer/PB01/TextureRect.visible = false
	$CrystalLayer/PB02/TextureRect.visible = false
	$CrystalLayer/PB03/TextureRect.visible = false
	$CrystalLayer/PB04/TextureRect.visible = false
	$CrystalLayer/PB05/TextureRect.visible = false
	$CrystalLayer/PB06/TextureRect.visible = false
	$CrystalLayer/PB07/TextureRect.visible = false
	
func _on_dimension_swap():
	#if $solids.visible:
	if Globals.in_alter_dimension == true:
		$solids.modulate.a = 0.25
		$AlterDimension.modulate.a = 0.8
		$solids.z_index = 100
		$AlterDimension.z_index = -100
		$solids.set_collision_layer_bit(1,0)
		$AlterDimension.set_collision_layer_bit(1,1)
		$permanent.position = Vector2()
		Globals.in_alter_dimension = false
	else:
		$solids.modulate.a = 0.8
		$AlterDimension.modulate.a = 0.25
		$solids.z_index = -100
		$AlterDimension.z_index = 100
		$AlterDimension.set_collision_layer_bit(1,0)
		$solids.set_collision_layer_bit(1,1)
		$permanent.position = Vector2(0,-1216)
		Globals.in_alter_dimension = true
	
	for points in get_tree().get_nodes_in_group("points"):
		if ($player.position - points.position).length() < 40:
			actualize_score(points.points)
			Globals.screen_shake(0.2,15, 8 * points.points)
			points.touched()
	
func actualize_score(points):
	score += points
	get_node("UI/Score").text = str(score)

func game_over():
	get_node("UI/GameOver/AnimGameOver").play("game_over")