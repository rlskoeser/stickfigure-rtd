extends "res://stick_figure.gd"

var sword_resting_rotation = 0
var sword_attack_rotation = 35

func _process(delta):
	super(delta)
	#$Sword.rotation = sword_resting_rotation
		
func attack():
	$Sword.attack()
