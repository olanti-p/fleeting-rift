extends CanvasLayer

var is_initializing = true




func _ready() -> void:
	%DifficultySlider.value = _diff_to_number(GlobalState.difficulty)
	is_initializing = false
	visible = false
	_update_difficulty_text()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = !visible


func _update_difficulty_text() -> void:
	var diff = _number_to_diff(%DifficultySlider.value)
	%DifficultyLabel.text = GlobalState.get_difficulty_name(diff)
	%DifficultyDescription.text = GlobalState.get_difficulty_description(diff)


func _number_to_diff(value: float) -> GlobalState.Difficulty:
	return (3 - roundi(value)) as GlobalState.Difficulty


func _diff_to_number(diff: GlobalState.Difficulty) -> float:
	return 3.0 - diff


func _on_difficulty_slider_value_changed(value: float) -> void:
	_update_difficulty_text()
	if is_initializing:
		return
	GlobalState.difficulty = _number_to_diff(value)


func _on_button_resume_pressed() -> void:
	visible = false


func _on_visibility_changed() -> void:
	if visible:
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	elif get_parent():
		get_parent().process_mode = Node.PROCESS_MODE_INHERIT
