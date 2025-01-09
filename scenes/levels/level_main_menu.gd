extends Level

func _ready() -> void:
	super()
	$Player.is_control_hackably_disabled = true
	await get_tree().create_timer(1.0).timeout
	for respawn in $Respawns.get_children():
		respawn.play_menu_anim()

func _process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("start_level"):
		_on_play_button_pressed()


var has_started: bool = false

func _on_play_button_pressed() -> void:
	if has_started:
		return
	has_started = true
	%PlayPressed.play()
	MusicController.stop_all()
	await get_tree().create_timer(0.3).timeout
	SceneTransition.do_normal("res://scenes/levels/level_map.tscn")
