extends Node2D
class_name SpinningStar

var is_dead: bool = false
var speed: float = 24.0

@onready var main_sprite: AnimatedSprite2D = $MainSprite
@onready var collision_detector: ShapeCast2D = $CollisionDetector


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	global_position.x += speed * delta
	if collision_detector.is_colliding():
		is_dead = true
		main_sprite.play("death")
		await main_sprite.animation_finished
		queue_free()
