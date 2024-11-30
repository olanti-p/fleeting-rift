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
	get_tree().change_scene_to_file(new_scene)


func _on_player_entered_glitch(new_scene: String) -> void:
	get_tree().change_scene_to_file(new_scene)


func _unhandled_key_input(raw_event: InputEvent) -> void:
	if !console_container.visible:
		return
	var event = raw_event as InputEventKey
	if event.is_pressed():
		print(event.keycode, "  :  ", event.as_text_keycode(), "  :u  ", event.unicode)
		match event.unicode:
			48: # 0
				_close_console()
			49: # 1
				pass
			50: # 2
				pass
			51: # 3
				pass
			52: # 4
				pass
			53: # 5
				pass
			54: # 6
				pass
			55: # 7
				pass
			56: # 8
				pass
			57: # 9
				pass


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
		if console_open_timer.is_stopped():
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
	var player = body as Player
	player.fell_beyond_map_edge()
