extends CanvasLayer


func _should_be_visible() -> bool:
	return ThisRun.timer_started && !ThisRun.is_completed && !get_parent().is_glitch_level


func _ready() -> void:
	%TimerContainer.visible = _should_be_visible()


func _process(delta: float) -> void:
	if _should_be_visible():
		%TimerContainer.visible = true
		ThisRun.run_time += delta * AllRuns.get_difficulty_time_correction()
		%LevelTimeDisplay.text = Util.fmt_timer(ThisRun.run_time)
	else:
		%TimerContainer.visible = false
