extends Level

func _ready() -> void:
	super()
	ThisRun.current_level = 0
	is_glitch_level = true
	MusicController.play_finale()


func _process(delta: float) -> void:
	super(delta)


func _physics_process(_delta: float) -> void:
	main_camera.limit_top = 0
	main_camera.limit_bottom = 240
	main_camera.global_position = $Player.global_position
