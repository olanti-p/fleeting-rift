@tool
extends Area2D

@export var cheat_id: String = ""
@export var cheat_text: String = "CHEAT"
@onready var label: RichTextLabel = $Label
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



var is_collected: bool = false:
	set(value):
		is_collected = value
		if label:
			if is_collected:
				label.text = "%s" % cheat_text
			else:
				label.text = "[wave amp=8][color=#20a5a6]%s[/color][/wave]" % cheat_text


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	is_collected = AllRuns.get(cheat_id)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		is_collected = false
	else:
		collision_shape_2d.shape.size = label.size

func _on_body_entered(_body: Node2D) -> void:
	if !is_collected:
		is_collected = true
		AllRuns.set(cheat_id, true)
