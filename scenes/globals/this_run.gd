extends Node

var clouds_finished: bool = false
var bastion_finished: bool = false
var timer_started: bool = false
var run_time: float = 0.0
var current_level: int = 0
var final_time: float = 0.0
var is_completed: bool = false
var is_fall_damage_disabled: bool = false
#var is_double_jump_enabled: bool = false
#var is_dash_enabled: bool = false
var is_double_jump_enabled: bool = true
var is_dash_enabled: bool = true
var all_areas_unlocked: bool = false
var is_spike_damage_disabled: bool = false
var is_star_damage_disabled: bool = false
var is_laser_damage_disabled: bool = false
var is_stamina_hack_enabled: bool = false
var is_gravity_flipped: bool = false
var is_noclip_enabled: bool = false


func start_timer() -> void:
	run_time = 0.0
	timer_started = true


func reset_run() -> void:
	clouds_finished = false
	bastion_finished = false
	timer_started = false
	run_time = 0.0
	current_level = 0
	final_time = 0.0
	is_completed = false
	
