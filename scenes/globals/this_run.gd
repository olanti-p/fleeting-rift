extends Node

var clouds_finished: bool = false
var bastion_finished: bool = false
var timer_started: bool = false
var run_time: float = 0.0
var current_level: int = 0
var final_time: float = 0.0
var is_completed: bool = false

func start_timer() -> void:
	run_time = 0.0
	timer_started = true
