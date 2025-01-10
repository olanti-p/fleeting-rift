extends Control

var is_initializing = true

func _ready() -> void:
	%SliderSound.value = GlobalState.sound_volume
	%SliderMusic.value = GlobalState.music_volume
	is_initializing = false

func _on_slider_sound_value_changed(value: float) -> void:
	if is_initializing:
		return
	GlobalState.sound_volume = value

func _on_slider_music_value_changed(value: float) -> void:
	if is_initializing:
		return
	GlobalState.music_volume = value
