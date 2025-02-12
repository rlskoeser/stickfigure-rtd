extends Node

var yellow_ball = preload("res://ball.tscn")
var red_ball = preload("res://red_ball.tscn")
var blue_ball = preload("res://blue_ball.tscn")
var rock = preload("res://rock_ball.tscn")

signal destroyed

@export var launch_wait_min = 3
@export var launch_wait_max = 7
var level_num = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$blue_shield.off()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	$CannonTimer.set_paused(false)
	$CannonTimer.start()
	
func next_level():
	level_num += 1 
	# cannon gets faster (but don't go negative)
	launch_wait_min = max(launch_wait_min - 0.5, 0.25)
	launch_wait_max = max(launch_wait_max - 1, 1)
	
func choose_ball():
	# debug rock breaking weapons
	#return rock
	
	var random_float = randf()

	if level_num < 4:
		if random_float <= 0.6:
			# 60% chance of yellow being returned.
			return yellow_ball
		elif random_float <= 0.8:
			# 20% chance of red being returned.
			return red_ball
		else:
			# 20% chance of being returned.
			return blue_ball
	# level 4 and higher	
	else:
		if random_float <= 0.4:
			# 40% chance of yellow being returned.
			return yellow_ball
		elif random_float <= 0.6:
			# 20% chance of red being returned.
			return red_ball
		elif random_float <= 0.8:
			# 20% chance of rock being returned.
			return rock
		else:
			# 20% chance of being returned.
			return blue_ball

func _on_cannon_timer_timeout():
	# Create a new instance of the selected ball
	var ball = choose_ball().instantiate()
	# add to level assets group so main level wlll clear 
	# on new / restart level
	ball.add_to_group("level_assets")
	# connect signal handler to *this* instance
	if ball.name == "blue_ball":
		ball.connect("shields_up", _on_shields_up)
	# start at the configured launch position
	ball.position = $LaunchPosition.position
	
	var velocity = Vector2.RIGHT.normalized() * ball.speed
	ball.linear_velocity = velocity 
	# add the ball to the Main scene.
	add_child(ball)
	# restart the timer with variable in wait time
	$CannonTimer.start(randf_range(launch_wait_min, launch_wait_max)) 

func take_damage(damage):
	$HP.take_damage(damage)


func _on_hp_death():
	destroyed.emit()
	
func reset():
	# set hit points back to starting value
	$HP.reset()
	# turn off the shield
	$blue_shield.off()
	# any balls left on the scene are automatically
	# cleared by main next level method
	# as members of level_assets group

func _on_shields_up():
	$blue_shield.on()
