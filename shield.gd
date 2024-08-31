extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	# if we hit something that does domage, subtract from hp
	if ("damage" in body):
		$HP.take_damage(body.damage)
		body.hit()

func _on_hp_death():
	queue_free()
	#hide() # Player disappears after being hit.
	## Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)
	
#func reset():
	#show()
	#$CollisionShape2D.set_deferred("disabled", false)
	#$HP.reset()
