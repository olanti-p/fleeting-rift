extends Area2D

@onready var danger_particles: CPUParticles2D = $DangerParticles

func _ready() -> void:
	var scale_total = absf(scale.x) * absf(scale.y)
	danger_particles.amount = round(danger_particles.amount * scale_total)
	danger_particles.spread /= scale_total
