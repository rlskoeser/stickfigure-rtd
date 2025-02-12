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
		
	# clear all level-specific assets still in the scene,
	# i.e., stick guys, bullets, and arrows
	# (balls are children of the cannon scene)
	get_tree().call_group("level_assets", "queue_free")
	
	if next:
		# level number goes up
		level_num = level_num + 1
		$LevelLabel.set_text("Level %d" % level_num)
		$Cannon.next_level()
		
	# add a new chooser after a delay
	# - this is to avoid clicking to attack turning into 
	#   choosing a guy by accident
	await get_tree().create_timer(1.0).timeout
	
	current_chooser = chooser.instantiate()
	# as levels get higher, allow choosing more guys
	if level_num >= 6:
		current_chooser.slots(4)
	if level_num>= 10:
		current_chooser.slots(5)
	add_child(current_chooser)
	current_chooser.connect("go", _on_chooser_go)

	# reset cannon
	$Cannon.reset()
		
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
	# add to level asset group so we can easily clear
	new_guy.add_to_group("level_assets")
	# add to guys for counting
	new_guy.add_to_group("guys")
	new_guy.connect("death", _on_guy_death)
	if new_guy.name == "GunGuy":
		for node in new_guy.get_children():
			if node.name.contains('Gun'):
				# connect signal handler to *this* instance
				node.connect("shoot", _on_gun_shoot)
	elif new_guy.name == "ArrowGuy":
		for node in new_guy.get_children():
			if node.name.contains('Bow'):
				# connect signal handler to *this* instance
				node.connect("shoot", _on_bow_shoot)		
	# connect signal handler to *this* instance
	add_child(new_guy)
	if guys:
		$SpawnTimer.start()

func _on_gun_shoot(Bullet, location):
	var spawned_bullet = Bullet.instantiate()
	spawned_bullet.position = location
	spawned_bullet.add_to_group("level_assets")
	add_child(spawned_bullet)
	
func _on_bow_shoot(Arrow, location):
	var spawned_arrow = Arrow.instantiate()
	spawned_arrow.position = location
	spawned_arrow.add_to_group("level_assets")
	add_child(spawned_arrow)
	
func count_remaining_guys():
	# count the number of guys still in this level;
	# include unspawned guys in count so we don't consider
	# the player defeated when only on-screen guys are gone
	return guys.size() + get_tree().get_nodes_in_group("guys").size()

func _on_guy_death(guy):
	remove_child(guy)
	# if all guys are dead and gone...
	if count_remaining_guys() == 0:
		# restart current level instead of going to next level
		show_message("Defeated. Try again")
		play_level()

func _on_chooser_go(chosen_lineup) -> void:
	go(chosen_lineup)
	remove_child(current_chooser)
	$Cannon.start()
