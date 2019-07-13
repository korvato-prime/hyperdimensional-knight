extends CanvasLayer

func _ready():
	#get_node("player").connect("hit", self, "_on_damege_received")
	pass

func _on_damege_received():
	pass
	
func _process(delta):
	$ProgressBar/Label.text = "%s/%s" % [str(Globals.player_current_life), str(Globals.player_total_life)] 