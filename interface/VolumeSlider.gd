extends HSlider

func _ready():
	min_value = 0.0001
	step = 0.0001
	max_value = 1
	value = 1
	set_volume(value)

func set_volume(ratio : float):
	ratio = clamp(ratio, 0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(ratio))#log(ratio) * 20)

func _on_VolumeSlider_value_changed(value):
	set_volume(value)

