extends Node2D

@onready var hint_animation: AnimationPlayer = $HintAnimation
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hint_container: Node2D = $HintContainer


func _ready() -> void:
	hint_container.modulate = Color.TRANSPARENT


func _on_player_detector_body_entered(_body: Node2D) -> void:
	animation_player.play("do_open")


func _on_player_detector_body_exited(_body: Node2D) -> void:
	animation_player.play_backwards("do_open")


func _on_player_entry_detector_body_entered(_body: Node2D) -> void:
	hint_animation.play("show")


func _on_player_entry_detector_body_exited(_body: Node2D) -> void:
	hint_animation.play_backwards("show")
