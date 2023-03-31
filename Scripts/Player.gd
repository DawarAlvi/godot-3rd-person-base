extends KinematicBody

const RUN_SPEED = 6.0
const SPRINT_SPEED = 8.0
const ACCELERATION = 0.8
const DECELERATION = 0.5
const JUMP_FORCE = 15
const MAX_FALL_SPEED = 15

onready var camera_target = $"%CameraTarget"
onready var cam_y = $"%CamY"
onready var cam_x = $"%CamX"


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed : float
var velocity : Vector3


func _physics_process(delta):
	# Joypad Look
	var look_input = Input.get_vector("look_right","look_left", "look_down", "look_up")
	if InputEventJoypadMotion:
		cam_y.rotate_y(look_input.x * 0.02)
		cam_x.rotate_x(look_input.y * 0.02)
		cam_x.rotation_degrees.x = clamp($"%CamX".rotation_degrees.x, -80, 40)
	
	# Sprint
	speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else RUN_SPEED
	
	if is_on_floor():
	# Jump
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
	else:
	# Gravity
		velocity.y = move_toward(velocity.y, max(velocity.y - gravity, -MAX_FALL_SPEED), 0.7)
	
	# Movement
	var move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var move_dir = (cam_y.transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	
	if move_dir:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(move_dir.x, move_dir.z), delta * 10)
		velocity.x = move_toward(velocity.x, move_dir.x * speed, ACCELERATION)
		velocity.z = move_toward(velocity.z, move_dir.z * speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)
		
	velocity = move_and_slide(velocity, Vector3.UP, true)


func _input(event):
	if event is InputEventMouseMotion:
		cam_y.rotate_y(-event.relative.x * 0.002)
		cam_x.rotate_x(-event.relative.y * 0.002)
		cam_x.rotation_degrees.x = clamp($"%CamX".rotation_degrees.x, -80, 40)


func _unhandled_input(event):
	if event.is_action_pressed("primary_fire"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

