extends Node

signal death

@export var health = 5
var full_health

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(health)
	full_health = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update(n):
	health = max(n, 0)   # never go below 0 HP
	$Label.text = str(health)
	
	# handle HP zero
	if health < 1:
		death.emit()

func take_damage(n):
	health -= n
	update(health)
	
func reset():
	update(full_health)
	 
	
