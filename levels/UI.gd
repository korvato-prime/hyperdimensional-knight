extends CanvasLayer

onready var player_HP = get_parent().get_node("player/health_system")

func _ready():
	#get_node("player").connect("hit", self, "_on_damege_received")
	pass

func _on_damege_received():
	# player/health_system has already a health_changed signal
	pass
	
func _process(delta):
	$ProgressBar/Label.text = "%s/%s" % [str(player_HP.health), str(player_HP.health_max)] 
