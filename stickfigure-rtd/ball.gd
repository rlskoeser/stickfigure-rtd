extends RigidBody2D

@export var speed = 150 
@export var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	hide() # ball disappears after hitting player

func hit():
	queue_free()
	
	## hide the ball after running into player or shield
	#hide()
	## turn off collision - if we hit shield, don't hit player
	#$CollisionShape2D.set_deferred("disabled", true)
