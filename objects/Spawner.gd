extends Node2D

export (PackedScene) var spawnScene

var position_enemy = Vector2()

onready var timerNode = $Timer

export (float) var minWaitTime 
export (float) var maxWaitTime 

func _ready():
	randomize()
	timerNode.wait_time = rand_range(minWaitTime, maxWaitTime)
	start()
	$reference.queue_free()
	$effect.scale.x  = 1 / scale.x
	$effect.scale.y  = 1/ scale.y

func start():
	timerNode.start()

func _on_Timer_timeout():
	position_enemy.x  = 32 * rand_range(-scale.x + 1,scale.x - 1)
	position_enemy.y  = 32 * rand_range((-scale.y + 1)/2,(scale.y - 1)/2)

	
	$effect.global_position = global_position + position_enemy
	
	$anim.play("spawn")

func spawn():
	var spawnInstance = spawnScene.instance()
	if spawnInstance.name != "HealthPickup"  && spawnInstance.name != "BulletPickup":
		var enemy_health_multiplier = get_parent().enemy_health_multiplier
		spawnInstance.health_multiplier = enemy_health_multiplier 
		get_parent().get_node("EnemyContainer").add_child(spawnInstance)
	else:
		get_parent().add_child(spawnInstance)
	spawnInstance.global_position = global_position + position_enemy

	timerNode.wait_time = rand_range(minWaitTime, maxWaitTime)
	timerNode.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	spawn()
