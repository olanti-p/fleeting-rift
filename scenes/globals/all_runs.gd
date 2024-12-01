extends Node

var total_time_in_game: float = 0.0

#var cheat_reset: bool = false
#var cheat_reveal: bool = false
#var cheat_infinite_dash: bool = false
#var cheat_double_jump: bool = false
#var cheat_no_fall_damage: bool = false
#var cheat_unlock_map: bool = false
#var cheat_no_spike_damage: bool = false
#var cheat_infinite_stamina: bool = false
#var cheat_no_star_damage: bool = false
#var cheat_reverse_gravity: bool = false
#var cheat_no_laser_damage: bool = false
#var cheat_unstuck: bool = false
#var cheat_noclip: bool = false
#var cheat_timer: bool = false

var cheat_reset: bool = true
var cheat_reveal: bool = true
var cheat_infinite_dash: bool = true
var cheat_double_jump: bool = true
var cheat_no_fall_damage: bool = true
var cheat_unlock_map: bool = true
var cheat_no_spike_damage: bool = true
var cheat_infinite_stamina: bool = true
var cheat_no_star_damage: bool = true
var cheat_reverse_gravity: bool = true
var cheat_no_laser_damage: bool = true
var cheat_unstuck: bool = true
var cheat_noclip: bool = true
var cheat_timer: bool = true

func _process(delta: float) -> void:
	total_time_in_game += delta

func factory_reset() -> void:
	total_time_in_game = 0.0
	cheat_reset = false
	cheat_reveal = false
	cheat_infinite_dash = false
	cheat_double_jump = false
	cheat_no_fall_damage = false
	cheat_unlock_map = false
	cheat_no_spike_damage = false
	cheat_infinite_stamina = false
	cheat_no_star_damage = false
	cheat_reverse_gravity = false
	cheat_no_laser_damage = false
	cheat_unstuck = false
	cheat_noclip = false
	cheat_timer = false
	SceneTransition.do_glitched("res://scenes/levels/level_main_menu.tscn")
