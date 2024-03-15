extends Node

signal quest_updated(state : Array[int])

const REF_PLAYER = preload("res://assets/scenes/scn_player.tscn")
const SCENE_STRINGS = [
	"res://assets/scenes/scn_corredor.tscn",
	"res://assets/scenes/scn_main.tscn",
	"res://assets/scenes/scn_scene2.tscn",
	"res://assets/scenes/scn_casa2.tscn",
	]

var Player
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var stage : Array[int] = [0, 0]
var args = {
	"[0, 4]" = func(called) -> void:
		called.get_node("Parede2").visible = false
		called.get_node("arm_Porta2").visible = false
		called.get_node("ParedeFechada").visible = false
		called.get_node("ParedeFechada/ParedeFechada/CollisionShape3D").set_deferred("disbled", true)
		,
	"[1, 9]" = func(called) -> void:
		#called.get_node("ParedeFechada").visible = false
		called.get_node("Parede1").set_layer_mask_value(1, false)
		called.get_node("Parede1").set_layer_mask_value(2, true)
		called.get_node("Parede2").set_layer_mask_value(1, true)
		called.get_node("Corredor").set_layer_mask_value(1, true)
		#called.get_node("ParedeFechada").set_layer_mask_value(1, true)
		Player.camera.set_cull_mask_value(2, false)
		Player.camera.set_cull_mask_value(4, true)
		#called.get_node("AreaPortal2/Portal2").visible = false
		#called.get_node("AreaPortal1/Portal1").visible = false
		called.get_node("AreaPortal2/CollisionShape3D").set_deferred("disabled", true)
		called.get_node("AreaPortal2/Portal2/Portalport/Portalport_exit/PortalCamera_exit").set_cull_mask_value(1, false)
		called.get_node("AreaPortal1/Portal1/Portalport/Portalport_entrance/PortalCamera_entrance").set_cull_mask_value(1, false)
		called.get_node("AreaPortal2/Portal2/Portalport/Portalport_exit/PortalCamera_exit").set_cull_mask_value(4, false)
		called.get_node("AreaPortal1/Portal1/Portalport/Portalport_entrance/PortalCamera_entrance").set_cull_mask_value(4, false)
		
		called.get_node("loader/CollisionShape3D").set_deferred("disabled", true)
		called.get_node("deloader/CollisionShape3D").set_deferred("disabled", true)
		
		called.get_node("arm_Porta1").visible = false
		called.get_node("arm_Porta1/Skeleton3D/BoneAttachment3D/Porta1").unlock()
		called.get_node("arm_Porta2").visible = true
		called.get_node("arm_Porta2/Skeleton3D/BoneAttachment3D/Porta2").unlock()
		
		called.get_node("ParedeL/CollisionShape3D").set_deferred("disabled", true)
		called.get_node("ParedeR/CollisionShape3D").set_deferred("disabled", true)
		called.get_node("Chao/CollisionShape3D").set_deferred("disabled", true)
		,
	"[2, 1]" = func():
		get_parent().get_node("ScnMaster/Scene3/End").modulate = Color(1, 1, 1, 1)
		get_parent().get_node("ScnMaster/Scene3/Espelho/Quebrado").play()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		var timer = Timer.new()
		timer.one_shot = true
		timer.connect("timeout", func():get_parent().get_node("ScnMaster/Scene3/Espelho/Mus_End").play())
		add_child(timer)
		timer.start(2)
		,
}

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func gamestart():
	get_tree().get_nodes_in_group("Player")[0].player_interacted.connect(progress)
	Player = get_tree().get_nodes_in_group("Player")[0]
	quest_updated.emit(stage)

func progress(_agent, object, held, picked, used):
	#print("Começando estágio " + str(stage[0]) + " - " + str(stage[1]))
	match stage[0]:
		0: # Tutorial at home
			match stage[1]:
				0:
					if _agent.name == "Player" and object != null and object.name == "Copo2" and picked == true:
							stage[1] += 1
							quest_updated.emit(stage)
				1:
					if _agent.name == "Player" and not held.cheio and held.name == "Copo2" and used == true:
						stage[1] += 1
						quest_updated.emit(stage)
				2:
					if _agent.name == "Player" and not held.cheio and held.name == "Copo2" and used == true:
						stage[1] += 1
						quest_updated.emit(stage)
				3:
					if _agent.name == "Player" and not held.cheio and held.name == "Copo2" and used == true:
						stage[1] += 1
						quest_updated.emit(stage)
				4:
					if _agent.name == "AreaPortal1":
						stage[0] = 1
						stage[1] = 0
						quest_updated.emit(stage)
		1: # The doggo
			match stage[1]:
				0:
					if _agent.name == "Player" and object != null:
						if object.name == "PortaA":
							stage[1] += 1
							quest_updated.emit(stage)
				1:
					if _agent.name == "AreaDoge":
						stage[1] += 1
						quest_updated.emit(stage)
				2:
					if _agent.name == "Player" and object != null:
						if object.name == "doggo":
							stage[1] += 1
							quest_updated.emit(stage)
				3:
					if _agent.name == "AreaDoge":
						stage[1] += 1
						quest_updated.emit(stage)
				4:
					if _agent.name == "Player" and object != null:
						if object.name == "doggo":
							stage[1] += 1
							quest_updated.emit(stage)
				5:
					if _agent.name == "AreaDoge":
						stage[1] += 1
						quest_updated.emit(stage)
				6:
					if _agent.name == "Player" and object != null:
						if object.name == "doggo":
							stage[1] += 1
							quest_updated.emit(stage)
				7:
					if _agent.name == "AreaDoge":
						stage[1] += 1
						quest_updated.emit(stage)
				8:
					if _agent.name == "Player" and object != null:
						if object.name == "doggo":
							stage[1] += 1
							quest_updated.emit(stage)
				9:
					if _agent.name == "AreaPortal1":
						stage[0] = 2
						stage[1] = 0
						quest_updated.emit(stage)
					
		2:
			match stage[1]:
				0:
					if _agent.name == "AreaPortal2":
						stage[1] += 1
						quest_updated.emit(stage)
					pass
	#print("Estágio atual: " + str(stage[0]) + " - " + str(stage[1]))
