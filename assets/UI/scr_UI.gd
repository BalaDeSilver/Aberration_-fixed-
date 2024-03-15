extends Control

const CONTROLLER_FACE_PROMPTS_DOWN : Array = [
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_NA_Down.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_XB_Down.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_PS_Down.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_SW_Down.png"),
]

const CONTROLLER_FACE_PROMPTS_RIGHT : Array = [
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_NA_Right.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_XB_Right.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_PS_Right.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_SW_Right.png"),
]

const CONTROLLER_FACE_PROMPTS_LEFT : Array = [
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_NA_Left.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_XB_Left.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_PS_Left.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_SW_Left.png"),
]

const CONTROLLER_FACE_PROMPTS_UP : Array = [
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_NA_Up.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_XB_Up.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_PS_Up.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Buttons_SW_Up.png"),
]

const CONTROLLER_LEFT_ANALOG : Array = [
	preload("res://assets/prompts/controller/analog/Left_Stick_NA.png"),
	preload("res://assets/prompts/controller/analog/Left_Stick_XB.png"),
	preload("res://assets/prompts/controller/analog/Left_Stick_PS.png"),
	preload("res://assets/prompts/controller/analog/Left_Stick_SW.png"),
]

const CONTROLLER_RIGHT_ANALOG : Array = [
	preload("res://assets/prompts/controller/analog/Right_Stick_NA.png"),
	preload("res://assets/prompts/controller/analog/Right_Stick_XB.png"),
	preload("res://assets/prompts/controller/analog/Right_Stick_PS.png"),
	preload("res://assets/prompts/controller/analog/Right_Stick_SW.png"),
]

const CONTROLLER_LEFT_TRIGER : Array = [
	preload("res://assets/prompts/controller/shoulder_buttons/Left_Trigger_NA.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Left_Trigger_PS.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Left_Trigger_SW.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Left_Trigger_XB.png"),
]

const CONTROLLER_LEFT_BUTTON : Array = [
	preload("res://assets/prompts/controller/shoulder_buttons/Left_Button_NA.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Left_Button_PS.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Left_Button_SW.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Left_Button_XB.png"),
]

const CONTROLLER_RIGHT_BUTTON : Array = [
	preload("res://assets/prompts/controller/shoulder_buttons/Right_Button_NA.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Right_Button_PS.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Right_Button_SW.png"),
	preload("res://assets/prompts/controller/shoulder_buttons/Right_Button_XB.png"),
]

const CONTROLLER_SINGLE_FACE_BUTTON_RIGHT : Array = [
	preload("res://assets/prompts/controller/face_buttons/Face_Button_NA_Right.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Button_PS_Right.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Button_SW_Right.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Button_XB_Right.png"),
]

const CONTROLLER_SINGLE_FACE_BUTTON_LEFT : Array = [
	preload("res://assets/prompts/controller/face_buttons/Face_Button_NA_Left.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Button_PS_Left.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Button_SW_Left.png"),
	preload("res://assets/prompts/controller/face_buttons/Face_Button_XB_Left.png"),
]

const KEYBOARD_MOVEMENT_KEYS : Array = [
	preload("res://assets/prompts/keyboard/Arrows.png"),
	preload("res://assets/prompts/keyboard/WASD.png"),
]

const KEYBOARD_INTERACT_KEYS : Array = [
	preload("res://assets/prompts/keyboard/E_Key.png"),
	preload("res://assets/prompts/keyboard/F_Key.png"),
	preload("res://assets/prompts/keyboard/Mouse_Right.png"),
	preload("res://assets/prompts/keyboard/X_Key.png"),
]

const KEYBOARD_USE_KEYS : Array = [
	preload("res://assets/prompts/keyboard/Mouse_Left.png"),
	preload("res://assets/prompts/keyboard/Q_Key.png"),
]

var global_timer : int = 0
@export var should_animate : bool = false

var use_interact : bool = false

@onready var Player = get_parent()

func _ready():
	#%HowToLook.visible = false
	#%HowToWalk.visible = false
	#%HowToRun.visible = false
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	QuestManager.connect("quest_updated", animate_stuff)
	
	var bus_index = AudioServer.get_bus_index("Master")
	var value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	%PercentMaster.text = str(value * 100) + "%"
	%Master.value = value
	
	bus_index = AudioServer.get_bus_index("SFX")
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	%PercentSFX.text = str(value * 100) + "%"
	%SFX.value = value
	
	bus_index = AudioServer.get_bus_index("MUS")
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	%PercentMUS.text = str(value * 100) + "%"
	%MUS.value = value
	
	$Pause.visible = false
	
	#%Crosshair.position = get_viewport_rect().size / 2

func _process(_delta):
	var looking_at = Player.raycast.get_collider()
	if looking_at == null or not looking_at.is_in_group("Interactable"):
		if not $AnimationPlayer.is_playing():
			should_animate = false
		%PromptLabel.visible = false
		%txrPromptPC.visible = false
		%txrPromptController.visible = false
	else:
		should_animate = true
		%PromptLabel.text = looking_at.PROMPT_TEXT
		%PromptLabel.visible = true
		%txrPromptPC.visible = true
		%txrPromptController.visible = true
		
		if looking_at.use_interact and Player.holding == null:
			if not $AnimationPlayer.is_playing():
				should_animate = false
			%PromptLabel.visible = false
			%txrPromptPC.visible = false
			%txrPromptController.visible = false
		
		use_interact = looking_at.use_interact
		
	if should_animate:
		%txrLookController.texture = CONTROLLER_RIGHT_ANALOG[global_timer]
		
		%txrWalkController.texture = CONTROLLER_LEFT_ANALOG[global_timer]
		@warning_ignore("integer_division")
		%txrWalkPC.texture = KEYBOARD_MOVEMENT_KEYS[global_timer / int(2)]
		
		%txrRunController.texture = CONTROLLER_FACE_PROMPTS_DOWN[global_timer]
		%txrRunController2.texture = CONTROLLER_LEFT_TRIGER[global_timer]
		
		%txrInteractController.texture = CONTROLLER_FACE_PROMPTS_RIGHT[global_timer]
		%txrInteractController2.texture = CONTROLLER_LEFT_BUTTON[global_timer]
		%txrInteractPC.texture = KEYBOARD_INTERACT_KEYS[global_timer]
		
		%txrUseController.texture = CONTROLLER_FACE_PROMPTS_LEFT[global_timer]
		%txrUseController2.texture = CONTROLLER_RIGHT_BUTTON[global_timer]
		@warning_ignore("integer_division")
		%txrUsePC.texture = KEYBOARD_USE_KEYS[global_timer / int(2)]
		
		if not use_interact:
			%txrPromptPC.texture = KEYBOARD_INTERACT_KEYS[global_timer]
			%txrPromptController.texture = CONTROLLER_SINGLE_FACE_BUTTON_RIGHT[global_timer]
		else:
			@warning_ignore("integer_division")
			%txrPromptPC.texture = KEYBOARD_USE_KEYS[global_timer / int(2)]
			%txrPromptController.texture = CONTROLLER_SINGLE_FACE_BUTTON_LEFT[global_timer]

func animate_stuff(state):
	match state:
		[0,0]:
			%QuestLabel.text = "I'm thirsty. I should get a cup of water in the kitchen."
			$AnimationPlayer.queue("Tutorial_Look")
			$AnimationPlayer.queue("Tutorial_Walk")
			$AnimationPlayer.queue("Tutorial_Interact")
		[0,1]:
			%QuestLabel.text = "Drink water."
			$AnimationPlayer.queue("Tutorial_Use")
		[0,2]:
			%QuestLabel.text = "Still thirsty. I'll just drink more water."
		[0,3]:
			%QuestLabel.text = "This water does not quench my thirst. Even more water."
		[0,4]:
			%QuestLabel.text = "What the dog is barking at?"
		[1,0]:
			%QuestLabel.text = "Where's outside..?"
			$AnimationPlayer.queue("Tutorial_Run")
		[1,1]:
			%QuestLabel.text = "Approach the dog."
		[1,2]:
			%QuestLabel.text = "Pet the dog. He is a good boy :)"
		[1,3]:
			%QuestLabel.text = "Where's the good boy? :("
		[1,4]:
			%QuestLabel.text = "Pet the good boy."
		[1,5]:
			%QuestLabel.text = "It speaks truth."
		[1,6]:
			%QuestLabel.text = "I hate you..."
		[1,7]:
			%QuestLabel.text = "...because they hate you."
		[1,8]:
			%QuestLabel.text = "..."
		[1,9]:
			%QuestLabel.text = "Find yourself."
		[2,0]:
			%QuestLabel.text = "We are not that."
		[2,1]:
			%QuestLabel.text = "I am me."

func _input(_event):
	if Input.is_action_just_released("gp_escape"):
		if get_tree().paused:
			$Pause.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
		else:
			$Pause.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true

func _on_global_timer_timeout():
	global_timer += 1
	global_timer %= 4

func _on_master_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Master")
	%PercentMaster.text = str(value * 100) + "%"
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_sfx_value_changed(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	%PercentSFX.text = str(value * 100) + "%"
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_mus_value_changed(value):
	var bus_index = AudioServer.get_bus_index("MUS")
	%PercentMUS.text = str(value * 100) + "%"
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
