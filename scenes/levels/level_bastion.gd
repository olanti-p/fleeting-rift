extends Level

func _ready() -> void:
	super()
	ThisRun.current_level = 1
	MusicController.play_bastion()
	%ExitDoor.connect("has_been_entered", _this_door_entered)

func _process(delta: float) -> void:
	super(delta)

func _this_door_entered(_new_scene: String, _buggy: bool) -> void:
	ThisRun.bastion_finished = true
