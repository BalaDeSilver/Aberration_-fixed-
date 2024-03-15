extends Pickable

const PROMPT_TEXT = "Pick up"
const use_interact = false
const MAT_HOLD = preload("res://assets/materials/mat_VridoVisivel.tres")

var cheio = false

#@export var gambiarra : float

var barulhos = [
	preload("res://assets/audio/sfx/sfx_water.mp3"),
	preload("res://assets/audio/sfx/sfx_gulp.mp3"),
]

func interact(_player) -> bool:
	#var instance = SCN_COPO.instantiate()
	#_player.hand.add_child(self)
	get_child(0).set_deferred("disabled", true)
	get_parent().reparent(_player.hand)
	get_parent().position = Vector3.ZERO
	get_parent().rotation = Vector3.ZERO
	$"../Copo".set_surface_override_material(0, MAT_HOLD)
	_player.holding = self
	#get_parent().get_parent().visible = false
	#self
	#_player.remote_transform.remote_path = get_parent().get_path()
	#_player.holding = self
	return true

func use(_player) -> bool:
	if not $"../Copo/AnimationCopo".is_playing():
		if _player.raycast.get_collider() != null:
			if _player.raycast.get_collider().is_in_group("Espelho"):
				#$"../End".modulate = Color(1, 1, 1, 1)
				QuestManager.args[str(QuestManager.stage)].call()
				#get_tree().get_nodes_in_group("Player")[0].queue_free()
				return true
		if not cheio:
			if _player.raycast.get_collider() != null:
				if _player.raycast.get_collider().is_in_group("Torneira"):
					$"../Copo/AnimationCopo".play("copo_agua")
					$"../AudioCopo".stream = barulhos[0]
					$"../AudioCopo".play()
					cheio = true
					return true
		else:
			$"../Copo/AnimationCopo".play_backwards("copo_agua")
			$"../AudioCopo".stream = barulhos[1]
			$"../AudioCopo".play()
			cheio = false
			return true
	return false
