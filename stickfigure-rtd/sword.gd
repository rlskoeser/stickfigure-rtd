extends Area2D

@export var damage = 25
var in_range = false
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

func _on_body_entered(body):
	if attacking:
		body.take_damage(damage)
