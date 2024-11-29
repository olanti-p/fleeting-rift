extends Node2D
class_name Level

@onready var projectiles: Node2D = $Projectiles
@onready var console_open_timer: Timer = $ConsoleOpenTimer
@onready var console_container: MarginContainer = %ConsoleContainer
@onready var vfx_scanlines_1: CanvasLayer = $VFX_Scanlines1
@onready var vfx_scanlines_2: CanvasLayer = $VFX_Scanlines2
@onready var vfx_bad_blocks: CanvasLayer = $VFX_BadBlocks
@onready var main_camera: Camera2D = $MainCamera



@export var glitches_visible: bool = false:
	set(value):
		glitches_visible = value
		if vfx_scanlines_1:
			_update_glitch_vfx()


func _update_glitch_vfx() -> void:
	vfx_scanlines_1.visible = glitches_visible
	vfx_scanlines_2.visible = glitches_visible
	vfx_bad_blocks.visible = glitches_visible


func _ready() -> void:
	_update_glitch_vfx()
	console_container.visible = false
	for child in $Emitters.get_children():
		child.register_owner_level(self)
	for area in $CameraAreas.get_children():
		area.connect("player_entered", _on_camera_area_entered)


func _on_camera_area_entered(_player: Player, area: CameraArea) -> void:
	main_camera.global_position = area.get_camera_position()



var level_time: float = 0.0:
	set(value):
		level_time = value
		@warning_ignore("integer_division")
		var hours = floori(level_time) / 3600
		@warning_ignore("integer_division")
		var minutes = (floori(level_time) / 60) % 60
		var seconds = floori(level_time) % 60
		var milliseconds = floori(fmod(level_time, 1.0) * 10.0) % 10
		%LevelTimeDisplay.text = "%02d:%02d:%02d.%01d" % [hours, minutes, seconds, milliseconds]


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


func _process(delta: float) -> void:
	level_time += delta
	
	if Input.is_action_just_pressed("open_console"):
		if console_open_timer.is_stopped():
			console_open_timer.start()
		else:
			console_open_timer.stop()
			_open_console()


func add_projectile(projectile: Node2D, pos: Vector2) -> void:
	projectiles.add_child(projectile)
	projectile.global_position = pos
