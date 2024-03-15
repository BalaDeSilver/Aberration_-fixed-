extends StaticBody3D
class_name Pickable

func interact(_player) -> bool:
	get_parent().reparent(_player)
	get_parent().surface_material_override.render_priority = 100
	return false

func use(_player) -> bool:
	return false;
