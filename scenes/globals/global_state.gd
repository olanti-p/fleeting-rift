extends Node

var user_prefs: UserPreferences
var is_initializing: bool = true

enum Difficulty {
	Hard,
	Normal,
	Easy,
	Cakewalk,
}
var difficulty: Difficulty = Difficulty.Normal:
	set(value):
		difficulty = value
		user_prefs.difficulty = value
		if !is_initializing:
			user_prefs.save()
		Engine.time_scale = _get_difficulty_time_scale(difficulty)
var sound_volume: float = 1.0:
	set(value):
		sound_volume = value
		user_prefs.sound_volume = value
		if !is_initializing:
			user_prefs.save()
		var idx = AudioServer.get_bus_index("Sound")
		AudioServer.set_bus_volume_db(idx, linear_to_db(value))
		AudioServer.set_bus_mute(idx, value < 0.05)
var music_volume: float = 1.0:
	set(value):
		music_volume = value
		user_prefs.music_volume = value
		if !is_initializing:
			user_prefs.save()
		var idx = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(idx, linear_to_db(value))
		AudioServer.set_bus_mute(idx, value < 0.05)

func get_current_difficulty_time_scale() -> float:
	return _get_difficulty_time_scale(difficulty)


func get_difficulty_time_correction() -> float:
	return 1.0 / _get_difficulty_time_scale(difficulty)


func get_animation_correction() -> float:
	return get_difficulty_time_correction()


func _get_difficulty_stamina_decay(diff: Difficulty) -> bool:
	return diff == Difficulty.Hard || diff == Difficulty.Normal


func get_difficulty_stamina_decay() -> bool:
	return _get_difficulty_stamina_decay(difficulty)


func _get_difficulty_extra_platforms(diff: Difficulty) -> bool:
	return diff == Difficulty.Cakewalk


func get_difficulty_extra_platforms() -> bool:
	return _get_difficulty_extra_platforms(difficulty)


func _get_difficulty_time_scale(diff: Difficulty) -> float:
	match diff:
		Difficulty.Hard:
			return 1.0
		Difficulty.Normal:
			return 0.85
		Difficulty.Easy:
			return 0.75
		Difficulty.Cakewalk:
			return 0.6
		_:
			push_error("unimplemented")
			return 1.0


func get_difficulty_name(diff: Difficulty) -> String:
	match diff:
		Difficulty.Hard:
			return "Hard"
		Difficulty.Normal:
			return "Normal"
		Difficulty.Easy:
			return "Easy"
		Difficulty.Cakewalk:
			return "Cakewalk"
		_:
			push_error("unimplemented")
			return "?Unimplemented?"


func get_difficulty_description(diff: Difficulty) -> String:
	var text = ""
	if diff == Difficulty.Hard:
		text += "Original difficulty. "
	text += "The game runs at %d%% speed.\n" % roundi(_get_difficulty_time_scale(diff) * 100.0)
	if _get_difficulty_stamina_decay(diff):
		text += "Stamina drains while grabbing walls.\n"
	else:
		text += "Stamina does not drain while grabbing walls.\n"
	if _get_difficulty_extra_platforms(diff):
		text += "There are additional platforms to land on."
	else:
		text += "There are no changes to level geometry."
	return text


func _ready() -> void:
	user_prefs = UserPreferences.load_or_create()
	sound_volume = user_prefs.sound_volume
	music_volume = user_prefs.music_volume
	difficulty = user_prefs.difficulty
	is_initializing = false
