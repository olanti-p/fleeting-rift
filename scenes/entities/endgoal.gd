extends AnimatedSprite2D
class_name Endgoal

signal player_entered()

@export var is_disabled: bool = false

var is_armed: bool = true

func _ready() -> void:
	if is_disabled:
		$IdleParticles.emitting = false
		$IdleParticles.visible = false

func _process(_delta: float) -> void:
	if is_disabled:
		play("inactive")

func _on_player_detector_body_entered(_body: Node2D) -> void:
	if !is_armed || is_disabled:
		return
	is_armed = false
	$IdleParticles.emitting = false
	$IdleParticles.visible = false
	$VictoryParticles.emitting = true
	play("inactive")
	player_entered.emit()
