extends Level
class_name GlitchLevel

func _ready() -> void:
	super()
	ThisRun.current_level = 0
	is_timer_visible = false

func _process(delta: float) -> void:
	super(delta)
	
