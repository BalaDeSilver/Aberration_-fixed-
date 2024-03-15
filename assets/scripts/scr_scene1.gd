extends Node3D

const ENV_DEFAULT = preload("res://assets/environments/env_default.tres")

@onready var DogBarking = load("res://assets/scenes/scn_dog_barking.tscn").instantiate()

@export var bus_name : String

var onmainmenu : bool = true

func _ready():
	QuestManager.quest_updated.connect(progress)
	$Casa/arm_PortaPrincipal/Skeleton3D/BoneAttachment3D/PortaPrincipal.lock()
	$Casa/arm_PortaQuintal/Skeleton3D/BoneAttachment3D/PortaQuintal.lock()
	$Casa/arm_PortaQuarto/Skeleton3D/BoneAttachment3D/PortaQuarto.lock()
	
	var mat = %MainMenuScreen.mesh.surface_get_material(0)
	var tex = $SubViewportContainer/SubViewport.get_texture()
	mat.set_texture(BaseMaterial3D.TEXTURE_ALBEDO, tex)
	mat.set_texture(BaseMaterial3D.TEXTURE_EMISSION, tex)
	
	var aabb = %MainMenuScreen.mesh.get_aabb()
	var begin = %CameraMenu.unproject_position(%MainMenuScreen.global_position + Vector3(aabb.position.x, -aabb.position.y, aabb.position.z))
	var end = %CameraMenu.unproject_position(%MainMenuScreen.global_position + Vector3(aabb.end.x, -aabb.end.y, aabb.end.z))
	#print(str(aabb.position) + " - " + str(aabb.size) + " - " + str(aabb.end))
	#print(str(%CameraMenu.unproject_position(begin)) + " + " + str(%CameraMenu.unproject_position(end)))
	
	$SubViewportContainer.set_deferred("position", begin + Vector2(5, 0))
	$SubViewportContainer.set_deferred("size", end - begin + Vector2(5, 0))
	$SubViewportContainer.set_deferred("self_modulate", Color(1, 1, 1, 0))
	
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(0.5))

func progress(state : Array[int]):
	if state == [0, 4]:
		var corredor = load(QuestManager.SCENE_STRINGS[0]).instantiate()
		corredor.spawncoords = $Corredor_spawn_coords.global_position
		corredor.spawnrotation = $Corredor_spawn_coords.global_rotation
		get_tree().get_root().get_node("ScnMaster").add_child(corredor)
		corredor.wall1.add_child(DogBarking)
		DogBarking.position.z += 1
		DogBarking.play()
		#$Corredor_spawn_coords.add_child(corredor)
		
		QuestManager.args[str(state)].call_deferred(corredor)
		
		$Casa/arm_PortaQuintal/Skeleton3D/BoneAttachment3D/PortaQuintal.call_deferred("unlock")

func _on_btn_quit_pressed():
	get_tree().quit()

func _on_Master_slider_value_changed(value):
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

func _on_btn_play_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationPlayer.play("Start_Game")
	$MainMenu/Audio_Begin.play()

func _on_animation_player_animation_finished(_anim_name):
	var player = QuestManager.REF_PLAYER.instantiate()
	get_parent().add_child(player)
	player.set("camera.environment", ENV_DEFAULT)
	player.position = %Playcerholder.global_position
	player.rotation = %Playcerholder.global_rotation
	%CameraMenu.current = false
	QuestManager.call_deferred("gamestart")
