extends AnimatedSprite2D

func _ready() -> void:
	frame = randi_range(0, 7)
	%Big.disabled = !(frame == 0)
	%Medium.disabled = !(frame == 1 || frame == 2)
	%Small.disabled = !(frame >= 3)


func _on_lifetime_timeout() -> void:
	queue_free()
