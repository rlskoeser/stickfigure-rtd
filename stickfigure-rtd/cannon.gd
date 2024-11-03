extends Node

var yellow_ball = preload("res://ball.tscn")
var red_ball = preload("res://red_ball.tscn")
var blue_ball = preload("res://blue_ball.tscn")

signal destroyed

@export var launch_wait_min = 3
@export var launch_wait_max = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	$blue_shield.off()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start():
	$CannonTimer.start()
	# position = $LaunchPosition.position
	#show()
	#$CollisionShape2D.disabled = false
# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)
	
	
func choose_ball():
	#return blue_ball
	var random_float = randf()

	if random_float <= 0.6:
		# 60% chance of yellow being returned.
		return yellow_ball
	elif random_float <= 0.8:
		# 20% chance of red being returned.
		return red_ball
	else:
		# 20% chance of being returned.
		return blue_ball

func _on_cannon_timer_timeout():
	# Create a new instance of the selected ball
	var ball = choose_ball().instantiate()
	# connect signal handler to *this* instance
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
	$HP.reset()
	$blue_shield.off()

func _on_shields_up():
	$blue_shield.on()
