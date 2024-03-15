extends CharacterBody3D

signal player_interacted(player : Node3D, object : Node3D, held : Node3D, picked : bool, used : bool)

const CAMERA_MAX_ROTATION_Y = 1.5
const CAMERA_MIN_ROTATION_Y = -1.5
const FOOTSTEP_AUDIO = [
	preload("res://assets/audio/sfx/sfx_footstep_0.mp3"),
	preload("res://assets/audio/sfx/sfx_footstep_1.mp3"),
	preload("res://assets/audio/sfx/sfx_footstep_2.mp3"),
	preload("res://assets/audio/sfx/sfx_footstep_3.mp3"),
	preload("res://assets/audio/sfx/sfx_footstep_4.mp3"),
	preload("res://assets/audio/sfx/sfx_footstep_5.mp3"),
]

var isdebug = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var holding = null
var just_stopped = false
var step_latch = false

@onready var randomstep : AudioStreamRandomizer = AudioStreamRandomizer.new()
@onready var raycast : RayCast3D = $Pivot/Camera/RayCast3D
@onready var hand : Node3D = $Pivot/Camera/Hand
@onready var remote_transform : RemoteTransform3D = $Pivot/Camera/RemoteTransform
@onready var remote_transform2 : RemoteTransform3D = $Pivot/Camera/RemoteTransform2
@onready var camera : Camera3D = $Pivot/Camera

@export var camera_sensitivity = 0.005
@export var camera_sensitivity_controller = 3.5
@export var move_speed = 2.5
@export var run_speed = 4.0
@export var deceleration_speed = 15.0
@export var jump_velocity = 4.5

func _on_footstep_player_finished():
	if just_stopped and not step_latch and not %FootstepPlayer.playing:
		%FootstepPlayer.stream = FOOTSTEP_AUDIO[5]
		%FootstepPlayer.play()
		just_stopped = false
	step_latch = true

func _ready():
	for i in FOOTSTEP_AUDIO:
		randomstep.add_stream(-1, i, 1.0)
	randomstep.remove_stream(5)
	randomstep.random_pitch = 1.2
	randomstep.random_volume_offset_db = 1.5

func play_footstep(play : bool):
	if play:
		if not %FootstepPlayer.playing:
			#%FootstepPlayer.stream = FOOTSTEP_AUDIO[QuestManager.rng.randi_range(0, 4)]
			%FootstepPlayer.stream = randomstep
			%FootstepPlayer.play()
			step_latch = false
			just_stopped = false
	else:
		just_stopped = true

func _process(delta):
	var input_dir = Input.get_vector("gp_camera_left", "gp_camera_right", "gp_camera_up", "gp_camera_down")
	self.rotate_y(-input_dir.x * camera_sensitivity_controller * delta)
	%Pivot.rotate_x(-input_dir.y * camera_sensitivity_controller * delta)
	%Pivot.rotation.x = clamp(%Pivot.rotation.x, deg_to_rad(-75), deg_to_rad(80))

func _input(event):
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * camera_sensitivity)
		%Pivot.rotate_x(-event.relative.y * camera_sensitivity)
		%Pivot.rotation.x = clamp(%Pivot.rotation.x, deg_to_rad(-75), deg_to_rad(80))

	if event.is_action_pressed("gp_interact"):
		var interacted = $Pivot/Camera/RayCast3D.get_collider()
		if interacted != null and interacted.is_in_group("Interactable"):
			if not interacted is Pickable:
				var success = interacted.interact(self)
				if success:
					player_interacted.emit(self, interacted, holding, false, false)
			else:
				if not holding == null:
					print("TODO: add inventory")
				var success = interacted.interact(self)
				if success:
					player_interacted.emit(self, interacted, holding, true, false)
	
	if event.is_action_pressed("gp_use"):
		if not holding == null:
			var success = holding.use(self)
			if success:
				player_interacted.emit(self, raycast.get_collider(), holding, false, true)
	
	#if event.is_action_pressed("debugcamera"):
		#print("Coords: " + str(self.global_position))
		#if not isdebug:
			#$Pivot/Camera.position += Vector3(0.0, 2.0, 2.0)
			#isdebug = true
		#else:
			#$Pivot/Camera.position -= Vector3(0.0, 2.0, 2.0)
			#isdebug = false
		#var interacted = raycast.get_collider()
		#if interacted != null and interacted.has_method("unlock"):
			#interacted.unlock()
			#interacted.interact(self)
		##QuestManager.quest_updated.emit(QuestManager.stage)

func _physics_process(_delta):
	if not is_on_floor():
		velocity.y -= gravity * _delta

	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = jump_velocity

	var input_dir = Input.get_vector("gp_left", "gp_right", "gp_forward", "gp_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if Input.is_action_pressed("gp_run"):
			velocity.x = direction.x * run_speed
			velocity.z = direction.z * run_speed
		else:
			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed
		play_footstep(true)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration_speed)
		velocity.z = move_toward(velocity.z, 0, deceleration_speed)
		play_footstep(false)

	move_and_slide()
