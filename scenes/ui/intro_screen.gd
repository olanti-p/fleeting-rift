extends Control

var diff_descr: String
var text_hard: String
var text_normal: String
var text_easy: String
var text_cakewalk: String


func _ready() -> void:
	diff_descr = %DifficultyDescription.text
	text_hard = %ButtonHard.text
	text_normal = %ButtonNormal.text
	text_easy = %ButtonEasy.text
	text_cakewalk = %ButtonCakewalk.text
	%DifficultyDescription.modulate = Color.TRANSPARENT
	%ButtonConfirm.modulate = Color.TRANSPARENT
	%ButtonConfirm.disabled = true


func _update_text() -> void:
	%DifficultyDescription.modulate = Color.WHITE
	%ButtonConfirm.modulate = Color.WHITE
	%ButtonConfirm.disabled = false
	%DifficultyDescription.text = diff_descr % roundi(AllRuns.get_current_difficulty_time_scale() * 100.0)
	if AllRuns.difficulty == AllRuns.Difficulty.Hard:
		%ButtonHard.text = "> %s <" % text_hard
		%ButtonNormal.text = text_normal
		%ButtonEasy.text = text_easy
		%ButtonCakewalk.text = text_cakewalk
	elif AllRuns.difficulty == AllRuns.Difficulty.Normal:
		%ButtonHard.text = text_hard
		%ButtonNormal.text = "> %s <" % text_normal
		%ButtonEasy.text = text_easy
		%ButtonCakewalk.text = text_cakewalk
	elif AllRuns.difficulty == AllRuns.Difficulty.Easy:
		%ButtonHard.text = text_hard
		%ButtonNormal.text = text_normal
		%ButtonEasy.text = "> %s <" % text_easy
		%ButtonCakewalk.text = text_cakewalk
	else:
		%ButtonHard.text = text_hard
		%ButtonNormal.text = text_normal
		%ButtonEasy.text = text_easy
		%ButtonCakewalk.text = "> %s <" % text_cakewalk


func _on_button_hard_pressed() -> void:
	AllRuns.difficulty = AllRuns.Difficulty.Hard
	_update_text()


func _on_button_normal_pressed() -> void:
	AllRuns.difficulty = AllRuns.Difficulty.Normal
	_update_text()


func _on_button_easy_pressed() -> void:
	AllRuns.difficulty = AllRuns.Difficulty.Easy
	_update_text()


func _on_button_cakewalk_pressed() -> void:
	AllRuns.difficulty = AllRuns.Difficulty.Cakewalk
	_update_text()


func _on_button_confirm_pressed() -> void:
	SceneTransition.do_first_start()
