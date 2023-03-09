extends Button

signal screenshake

func _on_pressed() -> void:
	#lmao
	var i = $"../GridContainer/Intensity".value
	var f = $"../GridContainer/Frequency".value
	var d = $"../GridContainer/Duration".value
	emit_signal("screenshake", i, f, d)
