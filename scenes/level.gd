extends Node2D
class_name Level

@onready var projectiles: Node2D = $Projectiles

func _ready() -> void:
	for child in $Emitters.get_children():
		child.register_owner_level(self)


var level_time: float = 0.0:
	set(value):
		level_time = value
		@warning_ignore("integer_division")
		var hours = floori(level_time) / 3600
		@warning_ignore("integer_division")
		var minutes = (floori(level_time) / 60) % 60
		var seconds = floori(level_time) % 60
		var milliseconds = floori(fmod(level_time, 1.0) * 10.0) % 10
		%LevelTimeDisplay.text = "%02d:%02d:%02d.%01d" % [hours, minutes, seconds, milliseconds]


func _process(delta: float) -> void:
	level_time += delta


func add_projectile(projectile: Node2D, pos: Vector2) -> void:
	projectiles.add_child(projectile)
	projectile.global_position = pos
