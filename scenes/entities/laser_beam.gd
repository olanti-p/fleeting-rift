extends Node2D
class_name LaserBeam

var is_dead: bool = false
var speed: float = 32.0

@onready var main_sprite: AnimatedSprite2D = $MainSprite
@onready var collision_detector: ShapeCast2D = $CollisionDetector
@onready var hit_collision: CollisionShape2D = $HitArea/HitCollision


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	global_position += ($Direction.global_position - global_position).normalized() * speed * delta
	if collision_detector.is_colliding():
		is_dead = true
		hit_collision.disabled = true
		main_sprite.play("death")
		await main_sprite.animation_finished
		queue_free()
