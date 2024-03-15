extends Node3D

@onready var Player = get_tree().get_nodes_in_group("Player")[0]
@onready var cubo_AABB : AABB = $cubo/Cube.get_aabb()

@onready var speaker = $Speaker

var audios = [
	preload("res://assets/audio/sfx/sfx_son.mp3"),
	preload("res://assets/audio/sfx/sfx_aberration.mp3"),
	preload("res://assets/audio/sfx/sfx_failure.mp3"),
	preload("res://assets/audio/sfx/sfx_get_out.mp3"),
]

var playing = 0

func _ready():
	speaker.reparent(QuestManager.Player)
	#QuestManager.stage = [1,0]
	#QuestManager.emit_signal("quest_updated", QuestManager.stage)
	$LookingGlass.visible = true
	$LookingGlass.mesh.surface_get_material(0).set_shader_parameter("point_highlight", $doggo.global_position)
	$LookingGlass.mesh.surface_get_material(0).set_shader_parameter("mask_texture", $doggo/doggo/SubMask/Mask.get_texture())
	$doggo/doggo/SubMask/Mask.size = get_viewport().size
	Player.remote_transform.remote_path = $doggo/doggo/SubMask/Mask/MaskCamera.get_path()
	
	QuestManager.connect("quest_updated", progress)
	$doggo/AnimationPlayer.get_animation("metarigAction_001").loop_mode = Animation.LOOP_LINEAR
	$doggo/AnimationPlayer.queue("metarigAction_001")
	
	get_parent().get_node("corredor").wall1.get_node("DogBarking").reparent($doggo, false)
	$doggo/DogBarking.position = Vector3.ZERO
	
	$doggo/AreaDoge.connect("body_entered", _on_area_doge_body_entered)
	
	#print($Casa/House.get_aabb())
	#for i in get_tree().get_nodes_in_group("Collision"):
		#print(str(i) + " - " + str((func(): if i.get_parent().get_parent().get_parent().visible:return "visible" else: return "invisible").call()))
		#i.set_deferred("disabled", not i.get_parent().get_parent().get_parent().visible or not i.get_parent().visible)

func progress(state : Array[int]):
	if state == [1,3]:
		#$doggo/DogBarking.stop()
		#$doggo/DogBarking.queue_free()
		#$doggo/metarig/Skeleton3D/Doggo.visible = false
		#$doggo/doggo/CollisionShape3D.set_deferred("disabled", true)
		$AnimationPlayer.play("Domain_Expansion")
		$LookingGlass.visible = true
		$LookingGlass.reparent(Player)
	if state[0] == 1 and state[1] >= 2 and state[1] <= 8 and state[1] % 2 != 0:
		var randpos = Vector3.ZERO
		speaker.stream = audios[playing]
		speaker.play()
		playing += 1
		$doggo/AreaDoge/CollisionShape3D.scale = Vector3(3, 1, 3)
		
		randpos.x = QuestManager.rng.randf_range(15, 30)
		if QuestManager.rng.randi_range(0, 1) == 0:
			randpos.x *= -1
		
		randpos.z = QuestManager.rng.randf_range(15, 30)
		if QuestManager.rng.randi_range(0, 1) == 0:
			randpos.z *= -1
		
		$doggo.position += randpos
		Player.get_node("LookingGlass").mesh.surface_get_material(0).set_shader_parameter("point_highlight", $doggo.global_position)
		#print(str(state))
	if state == [1, 9]:
		var randpos = Vector3.ZERO
		
		speaker.stream = audios[playing]
		speaker.play()
		playing += 1
		
		randpos.x = QuestManager.rng.randf_range(15, 30)
		if QuestManager.rng.randi_range(0, 1) == 0:
			randpos.x *= -1
		
		randpos.z = QuestManager.rng.randf_range(15, 30)
		if QuestManager.rng.randi_range(0, 1) == 0:
			randpos.z *= -1
		
		$doggo.position += randpos
		$doggo.visible = false
		$doggo/DogBarking.stop()
		$doggo/DogBarking.queue_free()
		$doggo/doggo/CollisionShape3D.set_deferred("disabled", true)
		Player.get_node("LookingGlass").visible = false
		Player.get_node("LookingGlass").queue_free()
		
		var corredor = load(QuestManager.SCENE_STRINGS[0]).instantiate()
		corredor.spawncoords = $doggo.global_position + Vector3(0, 1.409, 0)
		corredor.spawnrotation = $doggo.rotation
		get_parent().add_child(corredor)
		
		QuestManager.args[str(state)].call_deferred(corredor)
		

func _on_area_doge_body_entered(body):
	if body.is_in_group("Player") and QuestManager.stage[1] <= 3 and QuestManager.stage[0] <= 1:
		var corredor = get_parent().get_node_or_null("corredor")
		if corredor != null:
			corredor.queue_free()
			$cubo/arm_PortaA/Skeleton3D/BoneAttachment3D/PortaA.lock()
	QuestManager.progress($doggo/AreaDoge, null, null, false, false)
