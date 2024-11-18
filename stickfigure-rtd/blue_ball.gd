extends "res://ball.gd"

signal shields_up

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit():
	# don't do normal ball behavior - die when shield dies
	pass

func start():
	$Timer.start()

func _on_timer_timeout():
	shields_up.emit()
	# delete this ball after it turns the shield on
	queue_free()
#
func push_back():
	# blue ball is not affected by the fan
	pass
