extends Node

var screen_shake

func screen_shake(duration = 0.2, fraquency = 15, amplitude = 16, priority = 0):
	screen_shake.start(duration, fraquency, amplitude, priority)
