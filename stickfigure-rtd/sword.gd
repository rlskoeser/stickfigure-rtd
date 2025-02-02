extends Area2D

@export var damage = 25
var body_in_range = null
var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack():
	attacking = true
	$AnimationPlayer.play("attack")
	# if already in range, do damage
	if body_in_range:
		body_in_range.take_damage(damage)

func _on_body_entered(body):
	# keep track of current overlapping body
	body_in_range = body
	# if we entered a body due to attack, body takes damage
	if attacking:
		body.take_damage(damage)


func _on_body_exited(body: Node2D) -> void:
	# clear out currently overlapping body
	body_in_range = null
	
