extends StaticBody3D

@export var PROMPT_TEXT : String = "Smash"
@export var use_interact : bool = true

func _ready():
	$"../End".modulate = Color(1, 1, 1, 0)

func interact(_var):
	return true
