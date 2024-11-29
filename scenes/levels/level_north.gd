extends Level

func _ready() -> void:
	super()
	ThisRun.current_level = 2

func _process(delta: float) -> void:
	super(delta)
