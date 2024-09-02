extends Node

var screen_size # Size of the game window.

var ShieldGuy = preload("res://shield_guy.tscn")
var SwordGuy = preload("res://sword_guy.tscn")
var GunGuy = preload("res://gun_guy.tscn")


var guys
var original_lineup = [ShieldGuy, SwordGuy, GunGuy]

# Called when the node enters the scene tree for the first time.
func _ready():
	guys = original_lineup.duplicate()
	$Cannon.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	# reset to original lineup and restart spawn timer
	guys = original_lineup.duplicate()
	$Cannon.reset()
	$SpawnTimer.start()
	
	# clear stick guys and balls still on the scene
	for node in get_children():
		if node.name.contains('Guy') or node.name.contains('ball') or node.name == "Bullet":
			node.queue_free()
		
func _on_cannon_destroyed():
	reset() 
	show_success()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_success():
	show_message("Winner!")

func _on_message_timer_timeout():
	$Message.hide()


func _on_spawn_timer_timeout():
	# get the first guy from the list of guys and instantiate
	var new_guy = guys.pop_front().instantiate(); 
	# move to spawn position and add to scene
	new_guy.position = $SpawnPosition.position
	if new_guy.name == "GunGuy":
		for node in new_guy.get_children():
			if node.name.contains('Gun'):
				# connect signal handler to *this* instance
				node.connect("shoot", _on_gun_shoot)
	# connect signal handler to *this* instance
	add_child(new_guy)
	if guys:
		$SpawnTimer.start()
		

func _on_gun_shoot(Bullet, location):
	var spawned_bullet = Bullet.instantiate()
	spawned_bullet.position = location
	add_child(spawned_bullet)
