extends Node2D

var score = 0
var highscore = Globals.highscore
var can_upgrade = 0
var enemy_health_multiplier = 1
var points_multiplier = 1

signal change_form

func _ready():
	randomize()
	Globals.in_alter_dimension = false
	_on_dimension_swap()
	
	$AlterDimension.set_collision_layer_bit(1,0)
	$player.connect("dimension_swap", self, "_on_dimension_swap")

func _process(delta):
	if $EnemyContainer.get_child_count() < 3:
		randomize()
		var to_generate = (randi() % 100) > 80
		if to_generate:
			var spawners = [$Spawner, $Spawner2, $Spawner3, $Spawner4]
			var spawner = spawners[randi() % spawners.size()]
			spawner.spawn()

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
		if can_upgrade > 0:
			get_node("upgrade_area/Collision").position.y = 52
		else:
			get_node("upgrade_area/Collision").position.y = 92
		for item in get_tree().get_nodes_in_group("items"):
			item.set_modulate(Color(0.1,0.1,0.1))

		$AlterDimension/TextureRect.visible = true
		$solids/TextureRect.visible = false
		$CrystalLayer/PB01.visible = true
		$CrystalLayer/PB02.visible = true
		$CrystalLayer/PB03.visible = true
		$CrystalLayer/PB04.visible = true
		$CrystalLayer/PB05.visible = true
		$DesertLayer/PL07.visible = false
		$DesertLayer/PL02.visible = false
		$DesertLayer/PL03.visible = false
		$DesertLayer/PL04.visible = false
		$DesertLayer/PL05.visible = false
		$DesertLayer/PL06.visible = false
		emit_signal("change_form")

	else:
		$solids.modulate.a = 0.8
		$AlterDimension.modulate.a = 0.25
		$solids.z_index = -100
		$AlterDimension.z_index = 100
		$AlterDimension.set_collision_layer_bit(1,0)
		$solids.set_collision_layer_bit(1,1)
		$permanent.position = Vector2(0,-1216)
		Globals.in_alter_dimension = true
		get_node("upgrade_area/Collision").position.y = 92
	
		for item in get_tree().get_nodes_in_group("items"):
			var dist = 60
			if item.is_in_group("point"):
				dist = 40
			if ($player.position - item.position).length() < dist:
				item.touched()
				
			item.set_modulate(Color(1,1,1))
		
		$AlterDimension/TextureRect.visible = false
		$solids/TextureRect.visible = true
		$CrystalLayer/PB01.visible = false
		$CrystalLayer/PB02.visible = false
		$CrystalLayer/PB03.visible = false
		$CrystalLayer/PB04.visible = false
		$CrystalLayer/PB05.visible = false
		$DesertLayer/PL07.visible = true
		$DesertLayer/PL02.visible = true
		$DesertLayer/PL03.visible = true
		$DesertLayer/PL04.visible = true
		$DesertLayer/PL05.visible = true
		$DesertLayer/PL06.visible = true
	
	
func actualize_score(points):
	score += points
	get_node("UI/Score").text = str(score)
	
	for i in [10, 25, 50, 100, 200, 400, 600, 800, 1000]:
		if i == score:
			can_upgrade += 1
			enemy_health_multiplier = enemy_health_multiplier + 1
			points_multiplier = points_multiplier + 1
	
	if can_upgrade > 0:
		$upgrade_area.visible = true

func game_over():
	get_node("UI").volume = -20
	get_node("UI/Score").hide()
	get_node("UI/GameOver/AnimGameOver").play("game_over")
