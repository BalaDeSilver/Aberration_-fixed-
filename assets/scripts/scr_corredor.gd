extends Node3D

@onready var Player = get_tree().get_nodes_in_group("Player")[0]
@onready var cube = $Corredor
@onready var wall1 = $Parede1
@onready var wall2 = $Parede2

var spawncoords = null
var spawnrotation = null

var stingerplayed = false

var canexpand = false

var vec = Vector3.FORWARD
var pos = Vector3.ZERO
var normvec = Vector3.FORWARD

#func _init(prev, next, hideinit, hidefin):
	#print("a")
	#$deloader.prevlvl = prev

func _ready():
	if spawncoords != null:
		self.global_position = spawncoords
	if spawnrotation != null:
		self.global_rotation = spawnrotation
	
	vec = %arm_Porta2.global_position - %arm_Porta1.global_position
	normvec = vec.normalized()
	pos = self.global_position
	
	#$Parede1/ParedeL/CollisionShape3D.set_deferred("disabled", not $Parede1.visible)
	#$Parede1/ParedeR/CollisionShape3D.set_deferred("disabled", not $Parede1.visible)
	#$Parede2/ParedeL/CollisionShape3D.set_deferred("disabled", not $Parede2.visible)
	#$Parede2/ParedeR/CollisionShape3D.set_deferred("disabled", not $Parede2.visible)
	
	%Portalport_entrance.size = get_viewport().size
	%Portalport_exit.size = get_viewport().size	
	var mat = %Portal1.mesh.surface_get_material(0)
	var tex = %Portalport_entrance.get_texture()
	mat.call_deferred("set_shader_parameter", "viewport_texture", tex)
	var mat2 = %Portal2.mesh.surface_get_material(0)
	tex = %Portalport_exit.get_texture()
	mat2.call_deferred("set_shader_parameter", "viewport_texture", tex)
	Player.remote_transform.force_update_cache()
	Player.remote_transform.remote_path = %PortalCamera_entrance.get_path()
	Player.remote_transform2.force_update_cache()
	Player.remote_transform2.remote_path = %PortalCamera_exit.get_path()
	%Portal2.visible = false
	%arm_Porta2.visible = false
	
	#print("Carregado")

func _process(_delta):
	if canexpand:
		var vector = pos - Player.global_position
		cube.scale.z = clamp((Vector3(vector.x * normvec.x, vector.y * normvec.y, vector.z * normvec.z) + normvec).length(), 2.5, 63.0/4.0 + 1)
		cube.position.z = (cube.scale.z * 2) - 2
		%arm_Porta1.position.z = cube.position.z * 2 + 1.9
		$Parede1.position.z = %arm_Porta1.position.z

func _on_area_portal_1_body_entered(body):
	if body.is_in_group("Player"):
		body.camera.set_cull_mask_value(1, true)
		body.camera.set_cull_mask_value(2, true)
		body.camera.set_cull_mask_value(5, false)
		if QuestManager.stage[1] >= 7 or QuestManager.stage[1] <= 9:
			body.camera.set_cull_mask_value(4, false)
		%PortalCamera_entrance.set_cull_mask_value(1, true)
		%PortalCamera_entrance.set_cull_mask_value(2, true)
		%PortalCamera_exit.set_cull_mask_value(1, true)
		%PortalCamera_exit.set_cull_mask_value(2, true)
		%Portal2.visible = true
		QuestManager.progress($AreaPortal1, null, null, false, false)

func _on_area_portal_1_body_exited(body):
	if body.is_in_group("Player"):
		var dir = body.global_position - $AreaPortal1.global_position;
		if dir.dot(vec) > 0:
			body.camera.set_cull_mask_value(2, false)
			body.camera.set_cull_mask_value(5, true)
			%Portal2.visible = false
			%PortalCamera_entrance.set_cull_mask_value(1, false)
			%PortalCamera_exit.set_cull_mask_value(1, false)
			$ParedeFechada/ParedeFechada/CollisionShape3D.set_deferred("disabled", false)
			
			$AreaPortal2/CollisionShape3D.set_deferred("disabled", true)
			
			$ParedeL/CollisionShape3D.set_deferred("disabled", true)
			$ParedeR/CollisionShape3D.set_deferred("disabled", true)
			$Chao/CollisionShape3D.set_deferred("disabled", true)
			$loader/CollisionShape3D.set_deferred("disabled", true)
			$deloader/CollisionShape3D.set_deferred("disabled", true)
			
			canexpand = false
			#print("Voltou pra casa")
		else:
			body.camera.set_cull_mask_value(1, false)
			body.camera.set_cull_mask_value(5, false)
			%Portal2.visible = true
			%PortalCamera_entrance.set_cull_mask_value(2, false)
			%PortalCamera_exit.set_cull_mask_value(2, false)
			%PortalCamera_exit.set_cull_mask_value(1, true)
			$ParedeFechada/ParedeFechada/CollisionShape3D.set_deferred("disabled", true)
			
			$AreaPortal2/CollisionShape3D.set_deferred("disabled", false)
			
			$ParedeL/CollisionShape3D.set_deferred("disabled", false)
			$ParedeR/CollisionShape3D.set_deferred("disabled", false)
			$Chao/CollisionShape3D.set_deferred("disabled", false)
			$loader/CollisionShape3D.set_deferred("disabled", false)
			$deloader/CollisionShape3D.set_deferred("disabled", false)
			
			canexpand = true
			#print("Foi pro corredor")
		

func _on_area_portal_2_body_entered(body):
	if body.is_in_group("Player"):
		body.camera.set_cull_mask_value(5, false)
		body.camera.set_cull_mask_value(1, true)
		body.camera.set_cull_mask_value(2, true)
		%PortalCamera_exit.set_cull_mask_value(1, true)
		%PortalCamera_exit.set_cull_mask_value(2, true)
		%Portal1.visible = true
		QuestManager.progress($AreaPortal2, null, null, false, false)
		var b0rk = get_node_or_null("Parede1/DogBarking")
		var cubo = get_node_or_null("../ScnLevel2/doggo")
		
		if b0rk != null and cubo != null:
			b0rk.reparent(cubo)
			b0rk.position = Vector3.ZERO

func _on_area_portal_2_body_exited(body):
	if body.is_in_group("Player"):
		var dir = body.global_position - $AreaPortal2.global_position;
		if dir.dot(vec) < 0:
			body.camera.set_cull_mask_value(2, false)
			body.camera.set_cull_mask_value(5, true)
			%Portal1.visible = false
			%PortalCamera_exit.set_cull_mask_value(1, false)
			#print("Foi pro cubo")
		else:
			body.camera.set_cull_mask_value(1, false)
			body.camera.set_cull_mask_value(5, false)
			%Portal1.visible = true
			%PortalCamera_exit.set_cull_mask_value(2, false)
			%PortalCamera_entrance.set_cull_mask_value(2, false)
			%PortalCamera_entrance.set_cull_mask_value(1, true)
			#print("Voltou pro corredor")

func _on_stinger_dettect_body_entered(body):
	if body.is_in_group("Player"):
		if not stingerplayed and canexpand:
			$StingerDettect/StingerPlayer.play()
			stingerplayed = true
