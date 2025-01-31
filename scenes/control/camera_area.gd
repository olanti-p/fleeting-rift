extends Area2D
class_name CameraArea

signal player_entered(player: Player, camera_area: CameraArea)
signal player_exited(player: Player, camera_area: CameraArea)

@onready var camera_fixed_position: Marker2D = $CameraFixedPosition

@export var camera_follow_mode: bool = false

var owner_level: Level = null
var attached_to: Camera2D = null


func _on_body_entered(body: Node2D) -> void:
	var player = body as Player
	assert(player)
	player_entered.emit(player, self)


func _on_body_exited(body: Node2D) -> void:
	var player = body as Player
	assert(player)
	player_exited.emit(player, self)


func has_player() -> bool:
	for body in get_overlapping_bodies():
		if body is Player:
			return true
	return false


func attach_camera(camera: Camera2D) -> void:
	attached_to = camera
	if camera_follow_mode:
		camera.limit_left = $TopLeft.global_position.x
		camera.limit_top = $TopLeft.global_position.y
		camera.limit_right = $BottomRight.global_position.x
		camera.limit_bottom = $BottomRight.global_position.y
	else:
		camera.limit_left = -10000000
		camera.limit_top = -10000000
		camera.limit_right = 10000000
		camera.limit_bottom = 10000000
		camera.global_position = camera_fixed_position.global_position
	if is_inside_tree():
		camera.reset_physics_interpolation()


func detach_camera() -> void:
	attached_to = null


func _physics_process(_delta: float) -> void:
	if attached_to && camera_follow_mode:
		attached_to.global_position = owner_level.get_player_global_pos()
		if owner_level.camera_needs_reset:
			attached_to.reset_physics_interpolation()
			owner_level.camera_needs_reset = false
