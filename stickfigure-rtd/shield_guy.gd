extends "res://stick_figure.gd"

func has_weapon():
	# shield guy has a weapon if the shield is still in the scene
	return $Shield
