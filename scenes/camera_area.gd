extends Area2D
class_name CameraArea

signal player_entered(player: Player, camera_area: CameraArea)

@onready var camera_fixed_position: Marker2D = $CameraFixedPosition


func _on_body_entered(body: Node2D) -> void:
	print("Player entered area ", name)
	var player = body as Player
	assert(player)
	player_entered.emit(player, self)

func get_camera_position() -> Vector2:
	return camera_fixed_position.global_position
