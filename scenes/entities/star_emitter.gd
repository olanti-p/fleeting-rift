extends Node2D
class_name StarEmitter

const packed_star: PackedScene = preload("res://scenes/entities/spinning_star.tscn")
@onready var main_sprite: AnimatedSprite2D = $MainSprite
@onready var star_spawn_pos: Marker2D = $StarSpawnPos
@onready var spawn_timer: Timer = $SpawnTimer

@export var spawn_time: float = 3.0
@export var first_delay: float = 0.0
var owner_level: Level = null


func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	if first_delay > 0:
		await get_tree().create_timer(first_delay).timeout
	spawn_timer.start()


func register_owner_level(level: Level) -> void:
	owner_level = level


func spawn_star() -> void:
	var proj = packed_star.instantiate()
	proj.rotation = rotation
	owner_level.add_projectile(proj, star_spawn_pos.global_position)


func _on_spawn_timer_timeout() -> void:
	main_sprite.play("spawn")
	await main_sprite.animation_finished
	main_sprite.play("idle")
	spawn_star()
