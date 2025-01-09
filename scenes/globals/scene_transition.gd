extends CanvasLayer

@export var frame: int = 0:
	set(value):
		frame = value
		for child in $CanvasLayer.get_children():
			child.frame = value

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	$VFX_Scanlines1.visible = false
	$VFX_Scanlines2.visible = false
	$VFX_BadBlocks.visible = false
	frame = 7


func do_normal(new_scene: String) -> void:
	get_tree().paused = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(new_scene)
	get_tree().paused = false
	animation_player.play("fade_in")

var play_mm: bool = false


func do_glitched(new_scene: String) -> void:
	get_tree().paused = true
	MusicController.stop_all()
	$VFX_Scanlines1.visible = true
	$VFX_Scanlines2.visible = true
	$VFX_BadBlocks.visible = true
	$GlitchSound.play()
	frame = 4
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(new_scene)
	await get_tree().create_timer(1.0).timeout
	$VFX_Scanlines1.visible = false
	$VFX_Scanlines2.visible = false
	$VFX_BadBlocks.visible = false
	frame = 7
	get_tree().paused = false
	if play_mm:
		play_mm = false
		MusicController.play_main_menu()


func do_shutdown(new_scene: String) -> void:
	get_tree().paused = true
	frame = 0
	$ShutdownSound.play()
	MusicController.stop_all()
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(new_scene)
	animation_player.play("fade_in")
	MusicController.play_main_menu()
	await animation_player.animation_finished
	get_tree().paused = false


func do_first_start() -> void:
	get_tree().paused = true
	frame = 0
	MusicController.stop_all()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/levels/level_main_menu.tscn")
	animation_player.play("fade_in")
	MusicController.play_main_menu()
	await animation_player.animation_finished
	get_tree().paused = false
