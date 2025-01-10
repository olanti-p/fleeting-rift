extends Node

var total_time_in_game: float = 0.0


var current_level: Level = null

var cheat_reset: bool = false
var cheat_reveal: bool = false
var cheat_infinite_dash: bool = false
var cheat_double_jump: bool = false
var cheat_no_fall_damage: bool = false
var cheat_unlock_map: bool = false
var cheat_no_spike_damage: bool = false
var cheat_infinite_stamina: bool = false
var cheat_no_star_damage: bool = false
var cheat_reverse_gravity: bool = false
var cheat_no_laser_damage: bool = false
var cheat_unstuck: bool = false
var cheat_noclip: bool = false
var cheat_timer: bool = false

var all_cheats = [
	"cheat_reset",
	"cheat_reveal",
	"cheat_infinite_dash",
	"cheat_double_jump",
	"cheat_no_fall_damage",
	"cheat_unlock_map",
	"cheat_no_spike_damage",
	"cheat_infinite_stamina",
	"cheat_no_star_damage",
	"cheat_reverse_gravity",
	"cheat_no_laser_damage",
	"cheat_unstuck",
	"cheat_noclip",
	"cheat_timer",
]


func _set_all_cheats(value: bool) -> void:
	for cheat in all_cheats:
		set(cheat, value)


func _process(delta: float) -> void:
	total_time_in_game += delta * GlobalState.get_difficulty_time_correction()
	if Input.is_action_just_pressed("debug_enable_all_cheats"):
		_set_all_cheats(true)
	if Input.is_action_just_pressed("debug_disable_all_cheats"):
		_set_all_cheats(false)


func factory_reset() -> void:
	total_time_in_game = 0.0
	_set_all_cheats(false)
	SceneTransition.play_mm = true
	SceneTransition.do_glitched("res://scenes/levels/level_main_menu.tscn")
