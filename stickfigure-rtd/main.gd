extends Node

var screen_size # Size of the game window.

var guys
var level_num = 1
var chooser = preload("res://chooser.tscn")
var current_chooser

# Called when the node enters the scene tree for the first time.
func _ready():
	# add a new chooser
	current_chooser = chooser.instantiate()
	add_child(current_chooser)
	# connect signal handler to *this* instance
	current_chooser.connect("go", _on_chooser_go)
	
func go(lineup):	
	guys = lineup.duplicate()
	$Cannon.start()
	$SpawnTimer.start()
	$MessageTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func play_level(next=false):
	# reset to original lineup and restart spawn timer
	$Cannon/CannonTimer.set_paused(true)
	$Cannon/CannonTimer.stop()
	$Cannon.reset()
		
	# clear stick guys and bullets still in the scene
	# (balls are children of the cannon)
	for node in get_children():
		if node.name.contains('Guy') or node.name == "Bullet":
			node.queue_free()
	
	if next:
		# level number goes up
		level_num = level_num + 1
		$LevelLabel.set_text("Level %d" % level_num)
		$Cannon.next_level()
		
	# add a new chooser after a delay
	await get_tree().create_timer(1.0).timeout
	
	
	current_chooser = chooser.instantiate()
	add_child(current_chooser)
	current_chooser.connect("go", _on_chooser_go)
		
func _on_cannon_destroyed():
	show_success()
	# go to next level
	play_level(true)

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
	new_guy.connect("death", _on_guy_death)
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
	
func count_active_guys():
	# clear stick guys and balls still on the scene
	var count = 0
	for node in get_children():
		if node.name.contains('Guy'):
			count += 1
	return count

func _on_guy_death(guy):
	remove_child(guy)
	var guy_count = count_active_guys()
	# if all guys are dead and gone...
	if guy_count == 0:
		# restart current level instead of going to next level
		show_message("Defeated. Try again")
		play_level()

func _on_chooser_go(chosen_lineup) -> void:
	go(chosen_lineup)
	remove_child(current_chooser)
	$Cannon.start()
