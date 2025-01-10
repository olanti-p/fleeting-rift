extends Node


func stop_all() -> void:
	for child in get_children():
		var ch: AudioStreamPlayer = child
		ch.stop()


func play_main_menu() -> void:
	stop_all()
	if !$MusicMainMenu.playing:
		$MusicMainMenu.play()


func play_map() -> void:
	stop_all()
	if !$MusicMap.playing:
		$MusicMap.play()


func play_clouds() -> void:
	stop_all()
	if !$MusicDreamyClouds.playing:
		$MusicDreamyClouds.play()


func play_bastion() -> void:
	stop_all()
	if !$MusicBastion.playing:
		$MusicBastion.play()


func play_north() -> void:
	if $MusicFrozenNorthIntro.playing:
		var pos = $MusicFrozenNorthIntro.get_playback_position()
		stop_all()
		$MusicFrozenNorth.play(pos)
	else:
		stop_all()
		if !$MusicFrozenNorth.playing:
			$MusicFrozenNorth.play()


func play_north_intro() -> void:
	stop_all()
	if !$MusicFrozenNorthIntro.playing:
		$MusicFrozenNorthIntro.play()


func play_glitch() -> void:
	stop_all()
	if !$MusicHardwareFault.playing:
		$MusicHardwareFault.play()

func play_finale() -> void:
	stop_all()
	if !$MusicFinale.playing:
		$MusicFinale.play()
