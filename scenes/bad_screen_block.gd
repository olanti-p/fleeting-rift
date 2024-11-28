extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.speed_scale = randf_range(.5, 1.2)
	animation_player.advance(randf_range(0.0, 6.0))
