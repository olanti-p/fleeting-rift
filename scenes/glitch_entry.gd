extends Node2D

signal player_entered(player: Player)

func _randomize(anim: AnimationPlayer) -> void:
	anim.seek(randf_range(0.0, anim.current_animation_length))

func _ready() -> void:
	_randomize($AnimationPlayer1)
	_randomize($AnimationPlayer2)
	_randomize($AnimationPlayer3)
	_randomize($AnimationPlayer4)


func _on_player_detector_body_entered(body: Node2D) -> void:
	player_entered.emit(body as Player)
