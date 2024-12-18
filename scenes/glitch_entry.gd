extends Node2D

signal player_entered(new_scene: String)

@export var change_to_scene: String = ""
@onready var collision_shape_2d: CollisionShape2D = $PlayerDetector/CollisionShape2D


func _randomize(anim: AnimationPlayer) -> void:
	anim.seek(randf_range(0.0, anim.current_animation_length))

func _ready() -> void:
	_randomize($AnimationPlayer1)
	_randomize($AnimationPlayer2)
	_randomize($AnimationPlayer3)
	_randomize($AnimationPlayer4)


func _process(_delta: float) -> void:
	collision_shape_2d.disabled = !visible


func _on_player_detector_body_entered(_body: Node2D) -> void:
	player_entered.emit(change_to_scene)
