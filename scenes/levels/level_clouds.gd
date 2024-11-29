extends Level

func _ready() -> void:
	super()
	ThisRun.current_level = 0
	%ExitDoor.connect("has_been_entered", _this_door_entered)

func _process(delta: float) -> void:
	super(delta)

func _this_door_entered(_new_scene: String) -> void:
	ThisRun.clouds_finished = true
	
