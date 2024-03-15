extends StaticBody3D

const PROMPT_TEXT = "Open/Close"
const use_interact = false

@onready var animation_player = get_parent().get_parent().get_parent().get_parent().find_child("AnimationPlayer")
@onready var audio_player = $AudioStreamPlayer3D

@export var locked = false

var is_open = false
var soundopen = preload("res://assets/audio/sfx/sfx_door_open.mp3")
var soundclose = preload("res://assets/audio/sfx/sfx_door_close.mp3")
var soundlocked = preload("res://assets/audio/sfx/sfx_door_locked.mp3")

func _ready():
	var armature = get_parent().get_parent().get_parent()
	armature.visibility_changed.connect(func(): $CollisionShape3D.set_deferred("disabled", not armature.visible))
	$CollisionShape3D.disabled = not armature.visible

func lock():
	if locked:
		return
	if is_open:
		animation_player.play_backwards("arm_" + self.name + "Action")
		audio_player.stream = soundclose
		audio_player.play()
		is_open = false
	locked = true

func unlock():
	if not locked:
		return
	locked = false

func interact(_a) -> bool:
	if not animation_player.is_playing():
		if not locked:
			if is_open: #closing:
				animation_player.play_backwards("arm_" + self.name + "Action")
				audio_player.stream = soundclose
				audio_player.play()
			else: #opening:
				animation_player.play("arm_" + self.name + "Action")
				audio_player.stream = soundopen
				audio_player.play()
			is_open = not is_open
		else:
			audio_player.stream = soundlocked
			audio_player.play()
		return true
	return false
