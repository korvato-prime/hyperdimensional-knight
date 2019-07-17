extends Control

onready var level = get_parent().get_parent()

func game_over_menu():
	get_node("menu/Score").text += str(level.score)
	
	# actualize highscore
	if level.score > level.highscore:
		Globals.new_highscore(level.score)
		level.highscore = level.score
		get_node("menu/Highscore").text = "NEW RECORD!!!"
	else:
		get_node("menu/Highscore").text += str(level.highscore)
	
	get_node("menu/options/Retry").grab_focus()

func _on_Retry_pressed():
	get_tree().reload_current_scene()

func _on_Menu_pressed():
	Transition.fade_out("res://interface/TitleSceen.tscn")
	#get_tree().change_scene_to(load("res://interface/TitleSceen.tscn"))

