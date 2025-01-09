extends CanvasLayer

@onready var console_open_timer: Timer = $ConsoleOpenTimer
@onready var console_container: MarginContainer = %ConsoleContainer


func _is_console_open() -> bool:
	return console_container.visible


func _close_console() -> void:
	console_container.visible = false


func _open_console() -> void:
	console_container.visible = true


func _on_caret_reset_timer_timeout() -> void:
	%Caret.text = ">[pulse freq=2.0 ease=-20.0 color=#00000000]_[/pulse]"


func _show_cheat_msg(msg: String) -> void:
	%Caret.text = "> " + msg
	$CaretResetTimer.start()


func _play_cheatcode_success() -> void:
	$CheatcodeActivated.play()


func _play_cheatcode_fail() -> void:
	$CheatcodeFailed.play()


func _cheat_ok(msg: String) -> void:
	_play_cheatcode_success()
	_show_cheat_msg(msg)


func _cheat_fail(msg: String) -> void:
	_play_cheatcode_fail()
	_show_cheat_msg(msg)


func _cheat_reset() -> void:
	if !AllRuns.cheat_reset:
		return
	ThisRun.reset_run()
	SceneTransition.do_shutdown("res://scenes/levels/level_main_menu.tscn")


func _cheat_reveal() -> void:
	if !AllRuns.cheat_reveal:
		return
	if get_parent().has_fake_wall():
		get_parent().reveal_fake_wall()
		_cheat_ok("1 hidden wall(s) revealed")
	else:
		_cheat_fail("no hidden walls to reveal")


func _cheat_infinite_dash() -> void:
	if !AllRuns.cheat_infinite_dash:
		return
	if ThisRun.is_dash_enabled:
		_cheat_fail("Already active")
	else:
		ThisRun.is_dash_enabled = true
		_cheat_ok("Dash enabled")


func _cheat_double_jump() -> void:
	if !AllRuns.cheat_double_jump:
		return
	if ThisRun.is_double_jump_enabled:
		_cheat_fail("Already active")
	else:
		ThisRun.is_double_jump_enabled = true
		_cheat_ok("Double jump enabled")


func _cheat_no_fall_damage() -> void:
	if !AllRuns.cheat_no_fall_damage:
		return
	if ThisRun.is_fall_damage_disabled:
		_cheat_fail("Already active")
	else:
		ThisRun.is_fall_damage_disabled = true
		_cheat_ok("Fall damage disabled")


func _cheat_unlock_map() -> void:
	if !AllRuns.cheat_unlock_map:
		return
	if ThisRun.all_areas_unlocked:
		_cheat_fail("Already active")
	else:
		ThisRun.all_areas_unlocked = true
		_cheat_ok("All areas unlocked")


func _cheat_no_spike_damage() -> void:
	if !AllRuns.cheat_no_spike_damage:
		return
	if ThisRun.is_spike_damage_disabled:
		_cheat_fail("Already active")
	else:
		ThisRun.is_spike_damage_disabled = true
		_cheat_ok("Spike damage disabled")


func _cheat_infinite_stamina() -> void:
	if !AllRuns.cheat_infinite_stamina:
		return
	if ThisRun.is_stamina_hack_enabled:
		_cheat_fail("Already active")
	else:
		ThisRun.is_stamina_hack_enabled = true
		_cheat_ok("Stamina loss disabled")


func _cheat_no_star_damage() -> void:
	if !AllRuns.cheat_no_star_damage:
		return
	if ThisRun.is_star_damage_disabled:
		_cheat_fail("Already active")
	else:
		ThisRun.is_star_damage_disabled = true
		_cheat_ok("Star damage disabled")


func _cheat_reverse_gravity() -> void:
	if !AllRuns.cheat_reverse_gravity:
		return
	ThisRun.is_gravity_flipped = !ThisRun.is_gravity_flipped
	_cheat_ok("Gravity reversed")


func _cheat_no_laser_damage() -> void:
	if !AllRuns.cheat_no_laser_damage:
		return
	if ThisRun.is_laser_damage_disabled:
		_cheat_fail("Already active")
	else:
		ThisRun.is_laser_damage_disabled = true
		_cheat_ok("Laser damage disabled")


func _cheat_unstuck() -> void:
	if !AllRuns.cheat_unstuck:
		return
	if $Player.is_control_hackably_disabled:
		$Player.is_control_hackably_disabled = false
		_cheat_ok("Player controls reset")
	else:
		_cheat_fail("Player controls are fine")


func _cheat_noclip() -> void:
	if !AllRuns.cheat_noclip:
		return
	ThisRun.is_noclip_enabled = !ThisRun.is_noclip_enabled
	if ThisRun.is_noclip_enabled:
		_cheat_ok("Physics disabled")
	else:
		_cheat_ok("Physics enabled")


func _cheat_timer() -> void:
	if !AllRuns.cheat_timer:
		return
	ThisRun.run_time = 0.0
	_cheat_ok("Timer restarted")


func _unhandled_key_input(raw_event: InputEvent) -> void:
	if !console_container.visible:
		return
	var event = raw_event as InputEventKey
	if event.is_pressed():
		#print(event.keycode, "  :  ", event.as_text_keycode(), "  :u  ", event.unicode)
		match event.unicode:
			49: # 1
				_cheat_reset()
			50: # 2
				_cheat_reveal()
			51: # 3
				_cheat_no_fall_damage()
			52: # 4
				_cheat_double_jump()
			53: # 5
				_cheat_infinite_dash()
			54: # 6
				_cheat_unlock_map()
			55: # 7
				_cheat_no_spike_damage()
			56: # 8
				_cheat_infinite_stamina()
			57: # 9
				_cheat_no_star_damage()
			48: # 0
				_cheat_reverse_gravity()
		match event.keycode:
			KEY_Z:
				_cheat_no_laser_damage()
			KEY_U:
				_cheat_unstuck()
			KEY_N:
				_cheat_noclip()
			KEY_T:
				_cheat_timer()


func _ready() -> void:
	_close_console()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_console"):
		if _is_console_open():
			_close_console()
		elif console_open_timer.is_stopped():
			console_open_timer.start()
		else:
			console_open_timer.stop()
			_open_console()
