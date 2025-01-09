extends Level

@onready var fake_wall: Sprite2D = %FakeWall
@onready var reveal_radius: Area2D = %RevealRadius


func _ready() -> void:
	super()
	ThisRun.current_level = 0
	MusicController.play_clouds()
	%ExitDoor.connect("has_been_entered", _this_door_entered)

func _process(delta: float) -> void:
	super(delta)
	%LabelDash.visible = ThisRun.is_dash_enabled

func _this_door_entered(_new_scene: String, _buggy: bool) -> void:
	ThisRun.clouds_finished = true


func has_fake_wall() -> bool:
	return fake_wall != null


func reveal_fake_wall() -> void:
	if !fake_wall:
		return
	if reveal_radius.has_overlapping_bodies():
		fake_wall.queue_free()
		fake_wall = null
		reveal_radius = null
		$Ground/WorldBoundaries/Bottom.position.y = 517
