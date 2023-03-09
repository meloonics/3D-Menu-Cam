extends Label

func _ready() -> void:
	get_controller(0, !Input.get_joy_name(0).is_empty())
	Input.connect("joy_connection_changed", get_controller)

func get_controller(_device: int, connected: bool):
	if connected:
		set("theme_override_colors/font_color", Color.GREEN)
		set_text("Connected Controller: " + Input.get_joy_name(0))
	else:
		set("theme_override_colors/font_color", Color.RED)
		set_text("No Controller detected!")
