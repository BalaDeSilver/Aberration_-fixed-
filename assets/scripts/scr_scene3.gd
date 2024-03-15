extends Node3D

const SCN_CARA = preload("res://assets/scenes/scn_cara.tscn")

var cara

func _ready():
	cara = SCN_CARA.instantiate()

func _process(_delta):
	if cara.is_inside_tree():
		cara.global_position = Vector3(0, -0.877, 0) + $Espelho.global_position + ((QuestManager.Player.global_position - $Espelho.global_position) * Vector3(1, 1, -1))
		cara.global_rotation = - QuestManager.Player.global_rotation
	#cara.global_position = ((QuestManager.Player.global_position + Vector3(0, 0, 1.447)) * Vector3(1, 1, -1)) - Vector3(0, 0, 1.447)
	#cara.rotation = -QuestManager.Player.rotation + Vector3(0, 180, 0)

func _on_stand_here_body_entered(body):
	if body.is_in_group("Player"):
		if !cara.is_inside_tree():
			add_child(cara)
		$arm_PortaSuiteBanheiro/Skeleton3D/BoneAttachment3D/PortaSuiteBanheiro.lock()
		var corredor = get_parent().get_node_or_null("corredor")
		if corredor != null:
			corredor.queue_free()
		$Stand_Here/CollisionShape3D.set_deferred("disabled", true)
