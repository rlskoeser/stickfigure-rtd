extends RigidBody2D

@export var speed = 150 
@export var damage = 1
@export var weapon_breaker = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func hit():
	# remove the ball from the scene after running into player or shield
	queue_free()
	
func push_back():
	# set the ball to fly away
	var velocity = Vector2.LEFT.normalized() * self.speed * 2
	self.linear_velocity = velocity
