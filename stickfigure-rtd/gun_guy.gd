extends "res://stick_figure.gd"


func _process(delta):
	super(delta)
	#$Sword.rotation = sword_resting_rotation
		
func attack():
	$Gun.fire() 
