extends Node3D

@onready var corredor = $corredor

func _ready():
	$corredor.Player.camera.set_cull_mask_value(5, true)
	$corredor/ParedeL/CollisionShape3D.set_deferred("disabled", true)
	$corredor/ParedeR/CollisionShape3D.set_deferred("disabled", true)
	$corredor/Chao/CollisionShape3D.set_deferred("disabled", true)
	$corredor/deloader/CollisionShape3D.set_deferred("disabled", true)
	$corredor/loader/CollisionShape3D.set_deferred("disabled", true)
	$corredor/Parede1/ParedeL/CollisionShape3D.set_deferred("disabled", true)
	$corredor/Parede1/ParedeR/CollisionShape3D.set_deferred("disabled", true)
	$corredor/Parede2/ParedeL/CollisionShape3D.set_deferred("disabled", true)
	$corredor/Parede2/ParedeR/CollisionShape3D.set_deferred("disabled", true)
	$corredor/StingerDettect/CollisionShape3D.set_deferred("disabled", true)
	
	$arm_PortaA.visible = true
	
	$corredor/Parede1.visible = false
	$corredor/Parede2.visible = false
	$corredor/arm_Porta1.visible = false
	$corredor/arm_Porta2.visible = false
	
	$corredor/AreaPortal1.connect("body_entered", on_corredor_area_portal_1_body_entered)
	$corredor/AreaPortal1.connect("body_exited", on_corredor_area_portal_1_body_exited)
	
	var pos = $corredor.global_position
	var rot = $corredor.rotation
	$corredor.reparent(get_tree().root.get_node("ScnMaster"), true)
	#corredor.global_position = pos
	#corredor.rotation = rot
	

func on_corredor_area_portal_1_body_entered(body):
	if body.is_in_group("Player"):
		$Colliders/Chao/CollisionShape3D.set_deferred("disabled", true)
		$Colliders/Parede/CollisionShape3D.set_deferred("disabled", true)
		$Colliders/Parede2/CollisionShape3D.set_deferred("disabled", true)
		$Colliders/Parede3/CollisionShape3D.set_deferred("disabled", true)
		$Colliders/Parede4/CollisionShape3D.set_deferred("disabled", true)
		$Colliders/Parede5/CollisionShape3D.set_deferred("disabled", true)
		
		corredor.get_node("ParedeL/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("ParedeR/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("Chao/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("deloader/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("loader/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("Parede1/ParedeL/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("Parede1/ParedeR/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("Parede2/ParedeL/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("Parede2/ParedeR/CollisionShape3D").set_deferred("disabled", false)
		corredor.get_node("StingerDettect/CollisionShape3D").set_deferred("disabled", false)

func on_corredor_area_portal_1_body_exited(body):
	print(str(body))
	print(str(corredor))
	if body.is_in_group("Player"):
		var dir = body.global_position - corredor.get_node("AreaPortal1").global_position;
		if dir.dot(corredor.vec) < 0:
			corredor.get_node("ParedeL/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("ParedeR/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("Chao/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("deloader/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("loader/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("Parede1/ParedeL/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("Parede1/ParedeR/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("Parede2/ParedeL/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("Parede2/ParedeR/CollisionShape3D").set_deferred("disabled", true)
			corredor.get_node("StingerDettect/CollisionShape3D").set_deferred("disabled", true)
		
			$Colliders/Chao/CollisionShape3D.set_deferred("disabled", false)
			$Colliders/Parede/CollisionShape3D.set_deferred("disabled", false)
			$Colliders/Parede2/CollisionShape3D.set_deferred("disabled", false)
			$Colliders/Parede3/CollisionShape3D.set_deferred("disabled", false)
			$Colliders/Parede4/CollisionShape3D.set_deferred("disabled", false)
			$Colliders/Parede5/CollisionShape3D.set_deferred("disabled", false)
			#print("Voltou pra casa")
		else:
			corredor.get_node("ParedeL/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("ParedeR/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("Chao/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("deloader/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("loader/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("Parede1/ParedeL/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("Parede1/ParedeR/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("Parede2/ParedeL/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("Parede2/ParedeR/CollisionShape3D").set_deferred("disabled", false)
			corredor.get_node("StingerDettect/CollisionShape3D").set_deferred("disabled", false)
			
			$Colliders/Chao/CollisionShape3D.set_deferred("disabled", true)
			$Colliders/Parede/CollisionShape3D.set_deferred("disabled", true)
			$Colliders/Parede2/CollisionShape3D.set_deferred("disabled", true)
			$Colliders/Parede3/CollisionShape3D.set_deferred("disabled", true)
			$Colliders/Parede4/CollisionShape3D.set_deferred("disabled", true)
			$Colliders/Parede5/CollisionShape3D.set_deferred("disabled", true)
			#print("Foi pro corredor")
