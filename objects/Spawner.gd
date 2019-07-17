extends Position2D

export (PackedScene) var spawnScene

onready var timerNode = $Timer

export (float) var minWaitTime 
export (float) var maxWaitTime 

func _ready():
	randomize()
	timerNode.wait_time = rand_range(minWaitTime, maxWaitTime)
	$AnimationPlayer.play()

func start():
	timerNode.start()

func _on_Timer_timeout():
	var spawnInstance = spawnScene.instance()

	get_parent().add_child(spawnInstance)
	spawnInstance.global_position = global_position + Vector2(randi() % 40, randi() % 40)
	
	timerNode.wait_time = rand_range(minWaitTime, maxWaitTime)
	timerNode.start()