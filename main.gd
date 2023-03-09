extends Node3D

var selected_idx : int = 0
var state = DEFAULT : set = change_state
enum {DEFAULT, SELECT, FOCUS}

@onready var maincam = %MainCam

func _physics_process(delta: float) -> void:
	$Cursor.global_position = lerp($Cursor.global_position, $Objects.get_child(selected_idx).global_position, 0.2)

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		match state:
			DEFAULT:
				if Input.is_action_just_pressed("ui_accept"):
					change_state(SELECT)
				if Input.is_action_just_pressed("ui_focus_next"):
					change_state(SELECT)
				if Input.is_action_just_pressed("ui_focus_prev"):
					change_state(SELECT)
			SELECT:
				if Input.is_action_just_pressed("ui_accept"):
					change_state(FOCUS)
				if Input.is_action_just_pressed("ui_focus_next"):
					select(selected_idx + 1)
				if Input.is_action_just_pressed("ui_focus_prev"):
					select(selected_idx - 1)
				if Input.is_action_just_pressed("ui_cancel"):
					change_state(DEFAULT)
			FOCUS:
				if Input.is_action_just_pressed("ui_focus_next"):
					select(selected_idx + 1)
				if Input.is_action_just_pressed("ui_focus_prev"):
					select(selected_idx - 1)
				if Input.is_action_just_pressed("ui_cancel"):
					change_state(SELECT)

func change_state(v: int):
	state = v
	print(state)
	$Cursor.visible = state == SELECT
	match state:
		DEFAULT:
			maincam.set_go_to(null)
			maincam.set_look_at(null)
		SELECT:
			maincam.set_go_to(null)
			select(selected_idx)
		FOCUS:
			maincam.set_go_to($Viewpoints.get_child(selected_idx))

func select(v):
	selected_idx = posmod(v, $Objects.get_child_count())
	maincam.look_at_target = $Objects.get_child(selected_idx)
	if state == FOCUS:
		maincam.go_to_target = $Viewpoints.get_child(selected_idx)
