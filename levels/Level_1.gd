extends Node2D

func _ready():
	$AlterDimension.hide()
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
	else:
		#$AlterDimension.hide()
		#$solids.show()
		
		$solids.modulate.a = 1
		$AlterDimension.modulate.a = 0.25
		
		$solids.z_index = -100
		$AlterDimension.z_index = 100
		
		$AlterDimension.set_collision_layer_bit(1,0)
		$solids.set_collision_layer_bit(1,1)
