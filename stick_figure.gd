extends CharacterBody2D


signal hit

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var start_position
var start_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	start_position = position
	start_speed = speed

func _physics_process(delta):
	var velocity = Vector2.LEFT.normalized() * speed
	var collide = move_and_collide(velocity * delta)
	if (collide):
		var body = collide.get_collider()
		if "damage" in body:
			$HP.take_damage(body.damage)
			body.hit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.play()

func _on_body_entered(body):
	pass
	## if we hit something that does domage, subtract from hp
	#print('stickfigure body entered:')
	#print(body)
	#if "damage" in body:
		#$HP.take_damage(body.damage)
		#body.hit()
	#else:  # assume for now we ran into the cannon
		#speed = 0


func _on_hp_death():
	queue_free()


func _on_hit():
	pass # Replace with function body.

func attack():
	# default stick figure guy has no attack
	pass

func _on_input_event(viewport, event, shape_idx):
	# mouse event and pressed (click); not filtering on pressed gets two events (down/up)
	if event is InputEventMouseButton and event.pressed:
		attack()
