extends CanvasLayer

onready var player_HP = get_parent().get_node("player/health_system")
onready var player = get_parent().get_node("player")
onready var HP_bar = get_node("HP/HP_bar")
onready var HP_text = get_node("HP/HP_text")
onready var Sta_bar = get_node("Stamina/Sta_bar")
onready var Ammo_bar = get_node("Ammo/Ammo_bar")
onready var bg_music = get_parent().get_node("bg_music")
var volume = 0

func _process(delta):
	HP_text.text = "%s / %s" % [player_HP.health, player_HP.health_max]
	var HP = 307 * player_HP.health / player_HP.health_max
	if HP > HP_bar.margin_right:
		HP_bar.margin_right = (HP + HP_bar.margin_right)/2
	elif HP < HP_bar.margin_right:
		HP_bar.margin_right -= (HP_bar.margin_right - HP)/5
	
	var Sta = 307 * player.stamina / player.stamina_max
	if Sta > Sta_bar.margin_right:
		Sta_bar.margin_right = (Sta + Sta_bar.margin_right)/2
	elif Sta < Sta_bar.margin_right:
		Sta_bar.margin_right -= (Sta_bar.margin_right - Sta)/5
	
	var Ammo = 307 * player.ammo / player.ammo_max
	if Ammo > Ammo_bar.margin_right:
		Ammo_bar.margin_right = (Ammo + Ammo_bar.margin_right)/2
	elif Ammo < Ammo_bar.margin_right:
		Ammo_bar.margin_right -= (Ammo_bar.margin_right - Ammo)/5

	if volume != bg_music.volume_db:
		bg_music.volume_db += (volume - bg_music.volume_db)/50

func upgrade_menu_popup():
	get_tree().set_pause(true)
	var upgrade_menu = load("res://interface/PowerupSelection.tscn").instance()
	add_child(upgrade_menu)
	upgrade_menu.player = player

func _on_upgrade_area_body_entered(body):
	if body.is_in_group("player"):
		upgrade_menu_popup()
		volume = -20

func upgrade_menu_end():
	get_parent().can_upgrade -= 1
	if get_parent().can_upgrade == 0:
		get_parent().get_node("upgrade_area").visible = false
		get_parent().get_node("upgrade_area/Collision").position.y = 92
	get_tree().set_pause(false)
	volume = 0

