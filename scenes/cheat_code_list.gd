extends RichTextLabel

func _fc(hotkey: String, txt: String) -> String:
	return "* %s - [color=#20a5a6]%s[/color] \t" % [hotkey, txt]

func _process(_delta: float) -> void:
	var s = ""
	
	if AllRuns.cheat_reveal:
		s += _fc("1", "REVEAL")
	if AllRuns.cheat_reset:
		s += _fc("2", "RESET")
	
	s += "* 0 - Close"
	text = s
