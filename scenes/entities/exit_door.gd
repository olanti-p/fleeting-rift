extends Node2D
class_name ExitDoor

@export var change_to_scene: String = ""
@export var is_buggy: bool = false

@onready var hint_animation: AnimationPlayer = $HintAnimation
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hint_container: Node2D = $HintContainer

signal has_been_entered(new_scene: String, buggy: bool)

var is_being_entered: bool = false
var is_player_nearby: bool = false

func do_enter() -> void:
	if is_being_entered:
		return
	is_being_entered = true
	is_player_nearby = false
	hint_animation.play_backwards("show")
	animation_player.play("enter")
	await animation_player.animation_finished
	has_been_entered.emit(change_to_scene, is_buggy)
	is_being_entered = false


func _ready() -> void:
	hint_container.modulate = Color.TRANSPARENT


func _on_player_detector_body_entered(_body: Node2D) -> void:
	if is_being_entered:
		return
	is_player_nearby = true
	animation_player.play("do_open")


func _on_player_detector_body_exited(_body: Node2D) -> void:
	if is_being_entered:
		return
	is_player_nearby = false
	animation_player.play_backwards("do_open")


func _on_player_entry_detector_body_entered(body: Node2D) -> void:
	if is_being_entered:
		return
	hint_animation.play("show")
	var player = body as Player
	player.nearby_door = self


func _on_player_entry_detector_body_exited(body: Node2D) -> void:
	if is_being_entered:
		return
	hint_animation.play_backwards("show")
	var player = body as Player
	player.nearby_door = null

func _play_enter_sound() -> void:
	$EnteredSound.play()
