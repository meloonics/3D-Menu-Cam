extends MeshInstance3D

var show : bool = true
var scale_factor : float = 0.2

func new_value(v: float):
	scale = Vector3.ONE * v * scale_factor

func _on_r_stick_distance_drag_started() -> void:
	visible = true

func _on_r_stick_distance_drag_ended(_value_changed: bool) -> void:
	visible = show

func _on_label_9_toggled(button_pressed: bool) -> void:
	show = button_pressed
	visible = show
