extends "res://stick_figure.gd"

var sword_resting_rotation = 0
var sword_attack_rotation = 35

func _process(delta):
	super(delta)

func attack():
	# can only attack if we still have a sword!
	if $Sword:
		$Sword.attack()

func has_weapon():
	# sword guy has a weapon if the sword is still in the scene
	return $Sword

func break_weapon():
	if $Sword:
		$Sword.queue_free()
