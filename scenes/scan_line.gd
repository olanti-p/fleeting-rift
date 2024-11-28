extends Sprite2D

@export var invert_color: bool = false
@export_range(0.0, 1.0) var displacement: float = 0.01

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var animation_player_3: AnimationPlayer = $AnimationPlayer3


func _ready() -> void:
	material.set("shader_parameter/invert_color", invert_color)
	material.set("shader_parameter/displacement", displacement)
	animation_player.speed_scale = randf_range(.3, 1.4)
	animation_player.advance(randf_range(0.0, 20.0))
	animation_player_2.speed_scale = randf_range(.3, 1.4)
	animation_player_2.advance(randf_range(0.0, 4.0))
	animation_player_3.speed_scale = randf_range(1.0, 1.4)
	animation_player_3.advance(randf_range(0.0, 12.0))
