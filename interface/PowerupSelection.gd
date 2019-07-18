extends Control

var player
var options = [0,0,0]

func _ready():
	$PowerupContainer/Powerup01Button.grab_focus()
	while options[0] == options[1] or options[1] == options[2] or options[0] == options[2]:
		options = [randi() % 10,randi() % 10, randi() % 10]
	
func _on_Powerup01Button_focus_entered():
	#Change name label
	#Change description
	text_to_show(options[0])
	pass # Replace with function body.

func _on_Powerup02Button_focus_entered():
	text_to_show(options[1])
	pass # Replace with function body.

func _on_Powerup03Button_focus_entered():
	text_to_show(options[2])

func _on_Powerup01Button_pressed():
	power_up(options[0])
	upgraded()

func _on_Powerup02Button_pressed():
	power_up(options[1])
	upgraded()

func _on_Powerup03Button_pressed():
	power_up(options[2])
	upgraded()

func text_to_show(number):
	var text = []
	match (number):
		0:
			text = ["+ Stamina", "Because one never have enough punches when it's needed."]
		1:
			text = ["+ Stamina Regen.", "Spam melee attacks like a tomorrow doesn`t exist."]
		2:
			text = ["+ Bullets x Shoot", "One extra bullet for every shot."]
		3:
			text = ["Full Ammo", "Get ready to shoot!"]
		4:
			text = ["+ Ammo Capacity", ""]
		5:
			text = ["+ Max HP", ""]
		6:
			text = ["+2 HP", ""]
		7:
			text = ["+ Jump Height", ""]
		8:
			text = ["+ Speed", ""]
		9:
			text = ["+ Jumps", "gain an extra jump to use midair"]
	
	$NamePanel/NameLabel.text = text[0]
	$Panel/RichTextLabel.text = text[1]

func power_up(number):
	match (number):
		0:
			#more stamina
			player.stamina_max *= 1.20
		1:
			#more stamina regeneration
			player.stamina_recovery *= 1.1
		2:
			player.bullets_per_shoot += 1
		4:
			player.ammo_max *= 1.30
		3:
			player.ammo = player.ammo_max
		5:
			player.get_node("health_system").health_max += 1
		6:
			player.get_node("health_system").health += 2
			if player.get_node("health_system").health > player.get_node("health_system").health_max:
				player.get_node("health_system").health = player.get_node("health_system").health_max
		7:
			player.jump_velocity *= 1.3
		8:
			#move faster
			player.move_speed *= 1.2
		9:
			player.second_jump += 1

func upgraded():
	get_parent().get_node("anim_UI").play("post_upgrade")
	queue_free()
