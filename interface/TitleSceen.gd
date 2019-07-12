extends Control

func _ready():
	$VBoxContainer/NewGameButton.grab_focus()	
	$OptionsContainer.hide()
	$CreditsText.hide()

func _on_NewGameButton_pressed():
	Transition.fade_out("res://interface/TestScene.tscn")

func _on_OptionsButton_pressed():
	$VBoxContainer.hide()
	$OptionsContainer.show()
	$OptionsContainer/HSlider.grab_focus()
	
func _input(event):
	if Input.is_action_just_pressed("cancel"):
		$VBoxContainer.show()
		$VBoxContainer/NewGameButton.grab_focus()
		$OptionsContainer.hide()
		$CreditsText.hide()

func _on_CheckBox_toggled(button_pressed):
	if OS.window_fullscreen == false:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false

func _on_CreditsButton_pressed():
	$CreditsText.show()
	$VBoxContainer.hide()

func _on_ExitButton_pressed():
	get_tree().quit()
