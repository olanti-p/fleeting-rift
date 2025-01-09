extends Level

func _ready() -> void:
	super()
	ThisRun.current_level = 0
	is_glitch_level = true
	MusicController.play_finale()

func _process(delta: float) -> void:
	super(delta)
	$MainCamera.limit_top = 0
	$MainCamera.limit_bottom = 240
	$MainCamera.global_position = $Player.global_position
