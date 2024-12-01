extends Node2D
class_name Level

@onready var projectiles: Node2D = $Projectiles
@onready var console_open_timer: Timer = $ConsoleOpenTimer
@onready var console_container: MarginContainer = %ConsoleContainer
@onready var vfx_scanlines_1: CanvasLayer = $VFX_Scanlines1
@onready var vfx_scanlines_2: CanvasLayer = $VFX_Scanlines2
@onready var vfx_bad_blocks: CanvasLayer = $VFX_BadBlocks
@onready var main_camera: Camera2D = $MainCamera

var active_camera_area: CameraArea = null
var is_glitch_level: bool = false


@export var glitches_visible: bool = false:
	set(value):
		glitches_visible = value
		if vfx_scanlines_1:
			_update_glitch_vfx()


var is_timer_visible: bool = true:
	set(value):
		is_timer_visible = value
		%TimerContainer.visible = value


func _update_glitch_vfx() -> void:
	vfx_scanlines_1.visible = glitches_visible
	vfx_scanlines_2.visible = glitches_visible
	vfx_bad_blocks.visible = glitches_visible


func _ready() -> void:
	_update_glitch_vfx()
	is_timer_visible = ThisRun.timer_started && !ThisRun.is_completed
	console_container.visible = false
	if $DebugPlayerSpawner.spawn_enabled:
		$Player.global_position = $DebugPlayerSpawner.global_position
		$Player.respawn_position = $Player.global_position
	for child in $Emitters.get_children():
		child.register_owner_level(self)
	for area in $CameraAreas.get_children():
		area.owner_level = self
		area.connect("player_entered", _on_camera_area_entered)
	for door in $Doors.get_children():
		door.connect("has_been_entered", _on_player_entered_door)
	for door in $GlitchEntries.get_children():
		door.connect("player_entered", _on_player_entered_glitch)


func _on_camera_area_entered(_player: Player, area: CameraArea) -> void:
	if active_camera_area:
		active_camera_area.detach_camera()
	active_camera_area = area
	active_camera_area.attach_camera(main_camera)


func _on_player_entered_door(new_scene: String) -> void:
	SceneTransition.do_normal(new_scene)


func _enter_glitch_deferred(new_scene: String) -> void:
	SceneTransition.do_glitched(new_scene)

func _on_player_entered_glitch(new_scene: String) -> void:
	call_deferred("_enter_glitch_deferred", new_scene)

func _cheat_reset() -> void:
	if !AllRuns.cheat_reset:
		return
	ThisRun.reset_run()
	SceneTransition.do_shutdown("res://scenes/levels/level_main_menu.tscn")


func _reveal_fake_wall() -> void:
	pass


func _cheat_reveal() -> void:
	if !AllRuns.cheat_reveal:
		return
	_reveal_fake_wall()


func _cheat_infinite_dash() -> void:
	if !AllRuns.cheat_infinite_dash:
		return
	ThisRun.is_dash_enabled = true


func _cheat_double_jump() -> void:
	if !AllRuns.cheat_double_jump:
		return
	ThisRun.is_double_jump_enabled = true


func _cheat_no_fall_damage() -> void:
	if !AllRuns.cheat_no_fall_damage:
		return
	ThisRun.is_fall_damage_disabled = true


func _cheat_unlock_map() -> void:
	if !AllRuns.cheat_unlock_map:
		return
	ThisRun.all_areas_unlocked = true


func _cheat_no_spike_damage() -> void:
	if !AllRuns.cheat_no_spike_damage:
		return
	ThisRun.is_spike_damage_disabled = true


func _cheat_infinite_stamina() -> void:
	if !AllRuns.cheat_infinite_stamina:
		return
	ThisRun.is_stamina_hack_enabled = true


func _cheat_no_star_damage() -> void:
	if !AllRuns.cheat_no_star_damage:
		return
	ThisRun.is_star_damage_disabled = true


func _cheat_reverse_gravity() -> void:
	if !AllRuns.cheat_reverse_gravity:
		return
	ThisRun.is_gravity_flipped = !ThisRun.is_gravity_flipped


func _cheat_no_laser_damage() -> void:
	if !AllRuns.cheat_no_laser_damage:
		return
	ThisRun.is_laser_damage_disabled = true


func _cheat_unstuck() -> void:
	if !AllRuns.cheat_unstuck:
		return
	$Player.is_control_hackably_disabled = false


func _cheat_noclip() -> void:
	if !AllRuns.cheat_noclip:
		return
	ThisRun.is_noclip_enabled = !ThisRun.is_noclip_enabled


func _cheat_timer() -> void:
	if !AllRuns.cheat_timer:
		return
	ThisRun.run_time = 0.0


func _unhandled_key_input(raw_event: InputEvent) -> void:
	if !console_container.visible:
		return
	var event = raw_event as InputEventKey
	if event.is_pressed():
		print(event.keycode, "  :  ", event.as_text_keycode(), "  :u  ", event.unicode)
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


func _is_console_open() -> bool:
	return console_container.visible


func _close_console() -> void:
	console_container.visible = false


func _open_console() -> void:
	console_container.visible = true


func fmt_timer(val: float) -> String:
	var hours = floori(val) / 3600
	var minutes = (floori(val) / 60) % 60
	var seconds = floori(val) % 60
	var milliseconds = floori(fmod(val, 1.0) * 10.0) % 10
	return "%02d:%02d:%02d.%01d" % [hours, minutes, seconds, milliseconds]


func _process(delta: float) -> void:
	ThisRun.run_time += delta
	%LevelTimeDisplay.text = fmt_timer(ThisRun.run_time)
	
	if Input.is_action_just_pressed("open_console"):
		if _is_console_open():
			_close_console()
		elif console_open_timer.is_stopped():
			console_open_timer.start()
		else:
			console_open_timer.stop()
			_open_console()


func add_projectile(projectile: Node2D, pos: Vector2) -> void:
	projectiles.add_child(projectile)
	projectile.global_position = pos


func get_player_global_pos() -> Vector2:
	return $Player.global_position


func _on_world_boundaries_body_entered(body: Node2D) -> void:
	if ThisRun.is_fall_damage_disabled and !is_glitch_level:
		call_deferred("_enter_glitch_deferred", "res://scenes/levels/glitch_level_3.tscn")
	else:
		var player = body as Player
		player.fell_beyond_map_edge()
