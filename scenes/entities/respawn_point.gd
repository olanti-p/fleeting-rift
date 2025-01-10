extends Node2D
class_name RespawnPoint

@export var appear_checked: bool = false:
	set(value):
		appear_checked = value
		_update_appear()
@export var disable_gfx: bool = false
@export var is_checked: bool = false

@onready var respawn_pos_marker: Marker2D = $RespawnPosMarker
@onready var main_sprite: AnimatedSprite2D = $AnimatedSprite2D


func get_respawn_position() -> Vector2:
	return respawn_pos_marker.global_position


func _update_appear() -> void:
	if !main_sprite:
		return
	if appear_checked:
		main_sprite.play("idle_checked")
	else:
		main_sprite.play("idle")


func _ready() -> void:
	if disable_gfx:
		_update_appear()


func _process(_delta: float) -> void:
	main_sprite.set_speed_scale(GlobalState.get_animation_correction())


func _on_player_entered(player: Player) -> void:
	if is_checked:
		return
	is_checked = true
	player.set_respawn_point(self)
	if !disable_gfx:
		$ActivatedSound.play()
		main_sprite.play("checked")
		await main_sprite.animation_finished
		main_sprite.play("idle_checked")


func uncheck() -> void:
	if !is_checked:
		return
	is_checked = false
	if !disable_gfx:
		main_sprite.play("unchecked")
		await main_sprite.animation_finished
		main_sprite.play("idle")


func play_menu_anim() -> void:
	main_sprite.play("checked")
	await main_sprite.animation_finished
	main_sprite.play("idle_checked")


func _on_player_detector_body_entered(body: Node2D) -> void:
	var player = body as Player
	_on_player_entered(player)
