extends Area3D

var notabug = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		%arm_Porta2.visible = true
		$"../arm_Porta2/Skeleton3D/BoneAttachment3D/Porta2".lock()
		$"../Parede2".visible = true
		$"../Parede2/ParedeL/CollisionShape3D".set_deferred("disabled", false)
		$"../Parede2/ParedeR/CollisionShape3D".set_deferred("disabled", false)
		
		$"../AreaPortal1".visible = false
		$"../AreaPortal1/CollisionShape3D".set_deferred("disabled", true)
		
		var i = get_parent().get_parent().get_node("Scene" + str(QuestManager.stage[0]))
		i.call_deferred("queue_free")
		
		if not notabug and QuestManager.stage[0] != 2:
			$NotABug.play()
			notabug = true
		
		
		#print(str(get_tree()))
		#print("Deload de cena desativado")

