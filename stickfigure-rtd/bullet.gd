extends RigidBody2D

@export var velocity = Vector2.LEFT
@export var speed = 350 
@export var damage = 13


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = velocity * speed 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta):
	var collide = move_and_collide(velocity * speed * delta)
	if (collide):
		var body = collide.get_collider()
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
