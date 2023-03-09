extends Node3D

@export_range(0.0, 20.0) var lerp_speed : float = 5.0: set = set_lerp_speed
@export_range(0.0, 2.0) var wiggle_strength : float = 0.1: set = set_wiggle_strength
@export_range(0.0, 2.0) var wiggle_speed : float = 1.5: set = set_wiggle_speed
@export_range(1.0, 20.0) var motion_range_offset : float = 3.0: set = set_motion_range_offset

@export_node_path("Node3D") var default_go_to_target

@onready var cam : Camera3D = %Cam : get = get_cam
@onready var motion_track = $ScreenShake/MotionTrack
@onready var idle_wiggle = $ScreenShake/MotionTrack/IdleWiggle
@onready var rstick_motion_point = $RStickHandle/RStickPoint
@onready var _noise : FastNoiseLite = _set_up_noise()
@onready var tween : Tween

var r_motion : Vector3 = Vector3.ZERO
var _time : float = 0.0
var shake_intensity : float = 1.0
var look_at_target : Node3D = null: set = set_look_at
var go_to_target : Node3D = null: set = set_go_to

func _physics_process(delta: float) -> void:
	if %Cam.current:
		
		var dls = delta * lerp_speed
		
		#cam idle wiggle
		var noise_x = _noise.get_noise_1d(_time)
		var noise_y = _noise.get_noise_1d(-_time)
		var noise_sample = Vector3(noise_x, noise_y, 0) * wiggle_strength
		idle_wiggle.rotation = lerp(idle_wiggle.rotation, noise_sample, dls)
		
		#look at motion point
		var rm = r_motion.limit_length()
		rstick_motion_point.position = lerp(rstick_motion_point.position, Vector3(rm.x, rm.y, 0), dls)
		motion_track.global_transform = motion_track.global_transform.looking_at(rstick_motion_point.global_position)
		
		#screenshake
		$ScreenShake.position = lerp($ScreenShake.position, Vector3.ZERO, dls)
		
		#look at target
		var dir : Vector3 = Vector3.FORWARD
		if look_at_target:
			dir = global_position.direction_to(look_at_target.global_position)
		rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), dls)
		rotation.x = lerp_angle(rotation.x, atan2(dir.y, -dir.z), dls)
		
		#go_to_target:
		var t: Vector3 = Vector3.ZERO
		if go_to_target:
			t = go_to_target.global_position
		elif default_go_to_target:
			t = get_node(default_go_to_target).global_position
		global_position = lerp(global_position, t, dls)
		
		_time += delta


func _input(event: InputEvent) -> void:
	
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_RIGHT_X:
			r_motion.x = event.axis_value
		elif event.axis == JOY_AXIS_RIGHT_Y:
			r_motion.y = -event.axis_value


### PUBLIC

func screenshake(intensity: float, frequency: float, duration: float):
	$TScreenshakeFreq.start(1.0 / frequency)
	if tween:
		tween.kill()
	tween = create_tween()
	shake_intensity = intensity
	tween.tween_property(self, "shake_intensity", 0.0, duration)
	tween.tween_callback(_screenshake_end)
	_trauma()

### PRIVATE

func _set_up_noise() -> FastNoiseLite:
	var fnl = FastNoiseLite.new()
	fnl.seed = randi()
	fnl.frequency = 0.05 * wiggle_speed
	return fnl

func _trauma() -> void:
	if %Cam.current:
			var noise_x = _noise.get_noise_1d(_time * 300) * shake_intensity
			var noise_y = _noise.get_noise_1d(-_time * 900) * shake_intensity
			$ScreenShake.position = Vector3(noise_x, noise_y, 0)

func _screenshake_end() -> void:
	$TScreenshakeFreq.stop()

### SETGET

func get_cam() -> Camera3D:
	return cam

func set_go_to(v: Node3D):
	go_to_target = v

func set_look_at(v: Node3D):
	look_at_target = v

func set_lerp_speed(v: float) -> void:
	lerp_speed = v

func set_wiggle_strength(v: float) -> void:
	wiggle_strength = v

func set_wiggle_speed(v: float) -> void:
	wiggle_speed = v
	_noise.frequency = 0.05 * wiggle_speed

func set_motion_range_offset(v: float) -> void:
	motion_range_offset = v
	$RStickHandle.position.z = -motion_range_offset



