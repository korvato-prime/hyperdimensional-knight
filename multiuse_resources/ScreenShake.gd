extends Node

var TRANS = Tween.TRANS_SINE
var EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

var offset_camara_inicial

onready var camara = get_parent()

func _ready():
	Globals.screen_shake = self

func start(duration = 0.2, fraquency = 15, amplitude = 16, priority = 0):
	if priority >= self.priority:
		offset_camara_inicial = camara.offset
		self.amplitude = amplitude
		
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(fraquency)
		$Duration.start()
		$Frequency.start()
		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	rand += offset_camara_inicial

	$ShakeTween.interpolate_property(camara, "offset", camara.offset, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func _on_Frequency_timeout():
	_new_shake()

func _reset():
	$ShakeTween.interpolate_property(camara, "offset", camara.offset, offset_camara_inicial, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
	priority = 0

func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
