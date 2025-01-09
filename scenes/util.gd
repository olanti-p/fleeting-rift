extends Node

func fmt_timer(val: float) -> String:
	var hours = floori(val) / 3600
	var minutes = (floori(val) / 60) % 60
	var seconds = floori(val) % 60
	var milliseconds = floori(fmod(val, 1.0) * 10.0) % 10
	return "%02d:%02d:%02d.%01d" % [hours, minutes, seconds, milliseconds]
