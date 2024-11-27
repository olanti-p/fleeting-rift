extends Node2D
class_name RespawnPoint

var is_checked: bool = false

@onready var respawn_pos_marker: Marker2D = $RespawnPosMarker
@onready var main_sprite: AnimatedSprite2D = $AnimatedSprite2D


func get_respawn_position() -> Vector2:
	return respawn_pos_marker.global_position


func _on_player_entered(player: Player) -> void:
	if is_checked:
		return
	is_checked = true
	player.set_respawn_point(self)
	main_sprite.play("checked")
	await main_sprite.animation_finished
	main_sprite.play("idle_checked")


func uncheck() -> void:
	if !is_checked:
		return
	is_checked = false
	main_sprite.play("unchecked")
	await main_sprite.animation_finished
	main_sprite.play("idle")


func _on_player_detector_body_entered(body: Node2D) -> void:
	var player = body as Player
	_on_player_entered(player)
