extends Control

func _ready():
	$PowerupContainer/Powerup01Button.grab_focus()
	#Select 3 random powerups for available array in Globals
	#Total array, Selected and available
	
func _on_Powerup01Button_focus_entered():
	#Change name label
	#Change description
	$NamePanel/NameLabel.text = "SPIDER BOOTS"
	$Panel/RichTextLabel.text = "You can reverse gravity and stick to the ceilling"
	pass # Replace with function body.

func _on_Powerup02Button_focus_entered():
	$NamePanel/NameLabel.text = "MOM'S SHOES"
	$Panel/RichTextLabel.text = "Hits really hard"
	pass # Replace with function body.

func _on_Powerup03Button_focus_entered():
	$NamePanel/NameLabel.text = "DOUBLE CANNON"
	$Panel/RichTextLabel.text = "Shoots 2 bullets at once"
	pass # Replace with function body.

func _on_Powerup01Button_pressed():
	#Put into Globals selected array
	pass # Replace with function body.

func _on_Powerup02Button_pressed():
	pass # Replace with function body.

func _on_Powerup03Button_pressed():
	pass # Replace with function body.
