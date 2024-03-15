extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var toload = load(QuestManager.SCENE_STRINGS[QuestManager.stage[0] + 1]).instantiate()
		get_parent().get_parent().add_child(toload)
		if QuestManager.stage[0] == 1:
			toload.global_position = $"../Cubo_Location".global_position
			toload.global_rotation = $"../Cubo_Location".global_rotation
		elif QuestManager.stage[0] == 2:
			toload.global_position = $"../Banheiro_Location".global_position
			toload.global_rotation = $"../Banheiro_Location".global_rotation
		%arm_Porta1.visible = false
