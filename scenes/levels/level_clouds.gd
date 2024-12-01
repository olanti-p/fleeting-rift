extends Level

@onready var fake_wall: Sprite2D = %FakeWall
@onready var reveal_radius: Area2D = %RevealRadius


func _ready() -> void:
	super()
	ThisRun.current_level = 0
	%ExitDoor.connect("has_been_entered", _this_door_entered)

func _process(delta: float) -> void:
	super(delta)

func _this_door_entered(_new_scene: String) -> void:
	ThisRun.clouds_finished = true
	
func _reveal_fake_wall() -> void:
	if fake_wall:
		if reveal_radius.has_overlapping_bodies():
			fake_wall.queue_free()
			fake_wall = null
			reveal_radius = null
			$Ground/WorldBoundaries/Bottom.position.y = 517
