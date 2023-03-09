extends MeshInstance3D

var motion = Vector2.ZERO
var dragging : bool = false
var should_be_visible : bool = true

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
			if event.axis == JOY_AXIS_RIGHT_X:
				motion.x = event.axis_value
				if should_be_visible:
					if !dragging:
						visible = motion.length() >= 1.0
			elif event.axis == JOY_AXIS_RIGHT_Y:
				motion.y = event.axis_value
				if should_be_visible:
					if !dragging:
						visible = motion.length() >= 1.0

func _on_r_stick_distance_drag_started() -> void:
	visible = true
	dragging = true


func _on_r_stick_distance_drag_ended(_value_changed: bool) -> void:
	visible = false
	dragging = false


func _on_label_9_toggled(button_pressed: bool) -> void:
	should_be_visible = button_pressed
	if !button_pressed:
		visible = false
