extends Level

func _ready() -> void:
	super()
	%CertificateEntry.visible = false
	$VFX_AwardGlitchReveal.visible = false
	%EndgoalTextExpected.visible = false
	%EndgoalTextFail.visible = false
	MusicController.play_north()
	ThisRun.current_level = 2

func fmt_run_time_display() -> void:
	var tm: String
	if ThisRun.is_completed:
		tm = fmt_timer(ThisRun.final_time)
	else:
		tm = fmt_timer(ThisRun.run_time)
	%EndgoalTimer.text = "[%s]" % tm

func _process(delta: float) -> void:
	super(delta)
	fmt_run_time_display()


func _on_glitch_vfx_area_body_entered(_body: Node2D) -> void:
	$VFX_AwardGlitchReveal.visible = true

func _on_glitch_vfx_area_body_exited(_body: Node2D) -> void:
	$VFX_AwardGlitchReveal.visible = false

var has_triggered_reveal: bool = false

func _on_glitch_reveal_area_body_entered(_body: Node2D) -> void:
	if has_triggered_reveal:
		return
	has_triggered_reveal = true
	%GlitchRevealPlayer.play("reveal")
	MusicController.stop_all()
	await %GlitchRevealPlayer.animation_finished
	%CertificateEntry.visible = true


func _on_endgoal_player_entered() -> void:
	is_timer_visible = false
	ThisRun.final_time = ThisRun.run_time
	ThisRun.is_completed = true
	fmt_run_time_display()
	MusicController.play_map()
	await get_tree().create_timer(2.0).timeout
	%EndgoalTextExpected.visible = true
	await get_tree().create_timer(2.0).timeout
	if ThisRun.final_time < 3.0:
		SceneTransition.do_glitched("res://scenes/levels/level_win.tscn")
	else:
		%EndgoalTextFail.visible = true
