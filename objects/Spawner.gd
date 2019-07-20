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
	spawn()
	
	timerNode.wait_time = rand_range(minWaitTime, maxWaitTime)
	timerNode.start()

func spawn():
	var spawnInstance = spawnScene.instance()
	if spawnInstance.name != "HealthPickup"  && spawnInstance.name != "BulletPickup":
		get_parent().get_node("EnemyContainer").add_child(spawnInstance)
	else:
		get_parent().add_child(spawnInstance)
	spawnInstance.global_position = global_position + Vector2(randi() % 40, randi() % 40)