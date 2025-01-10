extends RichTextLabel

func _fc(hotkey: String, txt: String) -> String:
	return "* %s - [color=#20a5a6]%s[/color]    " % [hotkey, txt]

func _process(_delta: float) -> void:
	var s = ""
	
	if AllRuns.cheat_reset:
		s += _fc("1", "RESET")
	if AllRuns.cheat_reveal:
		s += _fc("2", "REVEAL")
	if AllRuns.cheat_no_fall_damage:
		s += _fc("3", "FEATHER")
	if AllRuns.cheat_double_jump:
		s += _fc("4", "DOUBLE")
	if AllRuns.cheat_infinite_dash:
		s += _fc("5", "DASH")
		s += "\n"
	if AllRuns.cheat_unlock_map:
		s += _fc("6", "UNLOCKMAP")
	if AllRuns.cheat_no_spike_damage:
		s += _fc("7", "NOSPIKES")
	if AllRuns.cheat_infinite_stamina:
		s += _fc("8", "GAINZ")
	if AllRuns.cheat_no_star_damage:
		s += _fc("9", "NOSTARS")
		s += "\n"
	if AllRuns.cheat_reverse_gravity:
		s += _fc("0", "REVGRAV")
	if AllRuns.cheat_no_laser_damage:
		s += _fc("Z", "NOLASERS")
	if AllRuns.cheat_unstuck:
		s += _fc("U", "UNSTUCK")
	if AllRuns.cheat_noclip:
		s += _fc("N", "NOCLIP")
		s += "\n"
	if AllRuns.cheat_timer:
		s += _fc("T", "TIMEOUT")
	
	s += "* I - Close"
	text = s
