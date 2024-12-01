extends Level

func _ready() -> void:
	super()
	is_timer_visible = false
	$Player.is_control_hackably_disabled = true
	await get_tree().create_timer(1.0).timeout
	MusicController.play_main_menu()
	for respawn in $Respawns.get_children():
		respawn.play_menu_anim()

func _process(delta: float) -> void:
	super(delta)


func _on_play_button_pressed() -> void:
	SceneTransition.do_normal("res://scenes/levels/level_map.tscn")
