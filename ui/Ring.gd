extends Node3D

var pscale = 0.2
var motion := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var factor = position.z * pscale
	$RStickPoint/Point.scale = Vector3(factor, factor, factor)

func _input(event: InputEvent) -> void:
	
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_RIGHT_X:
			motion.x = event.axis_value
			visible = motion.length() >= 1.0
		elif event.axis == JOY_AXIS_RIGHT_Y:
			motion.y = event.axis_value
			visible = motion.length() >= 1.0

func _on_r_stick_distance_drag_started() -> void:
	$Ring.visible = true


func _on_r_stick_distance_drag_ended(_value_changed: bool) -> void:
	$Ring.visible = false


func _on_r_stick_distance_value_changed(value: float) -> void:
	position.z = -value
	var factor = value * pscale
	$RStickPoint/Point.scale = Vector3(factor, factor, factor)
