extends Control

var total_time: float = 0.0


func _ready() -> void:
	total_time = AllRuns.total_time_in_game
	
	$LabelTitle.visible = false
	$LabelSubtitle.visible = false
	$LabelTotalText.visible = false
	$LabelTotalTime.visible = false
	$LabelTotalTime.text = "[%s]" % Util.fmt_timer(total_time)
	$LabelGoodJob.visible = false
	$LabelThanks.visible = false
	$PlayButton.visible = false
	$FactoryReset.visible = false
	await get_tree().create_timer(1.0).timeout
	$LabelTitle.visible = true
	await get_tree().create_timer(1.5).timeout
	$LabelSubtitle.visible = true
	await get_tree().create_timer(1.5).timeout
	$LabelTotalText.visible = true
	$LabelTotalTime.visible = true
	$LabelGoodJob.visible = true
	await get_tree().create_timer(1.5).timeout
	$LabelThanks.visible = true
	await get_tree().create_timer(3.0).timeout
	$PlayButton.visible = true
	$FactoryReset.visible = true

func _on_play_button_pressed() -> void:
	get_tree().quit()

func _on_factory_reset_pressed() -> void:
	AllRuns.factory_reset()
