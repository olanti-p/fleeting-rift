extends Control

var text_hard: String
var text_normal: String
var text_easy: String
var text_cakewalk: String


func _ready() -> void:
	text_hard = %ButtonHard.text
	text_normal = %ButtonNormal.text
	text_easy = %ButtonEasy.text
	text_cakewalk = %ButtonCakewalk.text
	%DifficultyDescription.modulate = Color.TRANSPARENT
	%ButtonConfirm.modulate = Color.TRANSPARENT
	%ButtonConfirm.disabled = true


func _set_button_text(btn: Node, diff: GlobalState.Difficulty) -> void:
	var dname = GlobalState.get_difficulty_name(diff)
	if GlobalState.difficulty == diff:
		btn.text = "> %s <" % dname
	else:
		btn.text = dname



func _update_text() -> void:
	%DifficultyDescription.modulate = Color.WHITE
	%ButtonConfirm.modulate = Color.WHITE
	%ButtonConfirm.disabled = false
	%DifficultyDescription.text = GlobalState.get_difficulty_description(GlobalState.difficulty)
	_set_button_text(%ButtonHard, GlobalState.Difficulty.Hard)
	_set_button_text(%ButtonNormal, GlobalState.Difficulty.Normal)
	_set_button_text(%ButtonEasy, GlobalState.Difficulty.Easy)
	_set_button_text(%ButtonCakewalk, GlobalState.Difficulty.Cakewalk)


func _on_button_hard_pressed() -> void:
	GlobalState.difficulty = GlobalState.Difficulty.Hard
	_update_text()


func _on_button_normal_pressed() -> void:
	GlobalState.difficulty = GlobalState.Difficulty.Normal
	_update_text()


func _on_button_easy_pressed() -> void:
	GlobalState.difficulty = GlobalState.Difficulty.Easy
	_update_text()


func _on_button_cakewalk_pressed() -> void:
	GlobalState.difficulty = GlobalState.Difficulty.Cakewalk
	_update_text()


func _on_button_confirm_pressed() -> void:
	SceneTransition.do_first_start()
