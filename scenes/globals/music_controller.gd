extends Node


func stop_all() -> void:
	for child in get_children():
		var ch: AudioStreamPlayer = child
		ch.stop()


func play_main_menu() -> void:
	stop_all()
	$MusicMainMenu.play()


func play_map() -> void:
	stop_all()
	$MusicMap.play()


func play_clouds() -> void:
	stop_all()
	$MusicDreamyClouds.play()


func play_bastion() -> void:
	stop_all()
	$MusicBastion.play()


func play_north() -> void:
	stop_all()
	$MusicFrozenNorth.play()


func play_glitch() -> void:
	stop_all()
	$MusicHardwareFault.play()
