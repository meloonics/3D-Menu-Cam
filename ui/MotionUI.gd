extends TextureRect

var motion : Vector2 = Vector2.ZERO

signal x_changed
signal y_changed

func _draw() -> void:
	var m = motion.limit_length()
	draw_circle(size / 2 + m * size / 2, 10.0, Color(1.0, 1.0, 1.0, 0.5))
	if motion != Vector2.ZERO:
		draw_circle(size / 2 + m * size / 2, 8.0, Color(1.0, 1.0, 1.0, 1.0))

func _input(event: InputEvent) -> void:
	
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_RIGHT_X:
			motion.x = event.axis_value
			emit_signal("x_changed", snapped(event.axis_value, 0.01))
			queue_redraw()
		elif event.axis == JOY_AXIS_RIGHT_Y:
			motion.y = event.axis_value
			emit_signal("y_changed", snapped(event.axis_value, 0.01))
			queue_redraw()
