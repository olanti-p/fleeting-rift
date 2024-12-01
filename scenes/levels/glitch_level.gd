extends Level

func _ready() -> void:
	super()
	ThisRun.current_level = 0
	is_timer_visible = false
	is_glitch_level = true
	MusicController.play_glitch()

func _process(delta: float) -> void:
	super(delta)
	
