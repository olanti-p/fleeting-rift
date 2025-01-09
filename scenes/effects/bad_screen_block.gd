extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export_range(0.0, 1.0) var displacement: float = 0.1


func _ready() -> void:
	material.set("shader_parameter/displacement", displacement)
	animation_player.speed_scale = randf_range(.5, 1.2)
	animation_player.advance(randf_range(0.0, 6.0))
