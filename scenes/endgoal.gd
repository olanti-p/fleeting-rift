extends AnimatedSprite2D
class_name Endgoal

signal player_entered()

var is_armed: bool = true

func _on_player_detector_body_entered(_body: Node2D) -> void:
	if !is_armed:
		return
	is_armed = false
	$IdleParticles.emitting = false
	$IdleParticles.visible = false
	$VictoryParticles.emitting = true
	play("inactive")
	player_entered.emit()
