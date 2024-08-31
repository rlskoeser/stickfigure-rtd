extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on():
	# show and enable collision
	show() 
	$HP.reset()
	$CollisionShape2D.set_deferred("disabled", false)
	
func off():
	# hide and don't collide
	hide() 
	$CollisionShape2D.set_deferred("disabled", true)

func take_damage(damage):
	$HP.take_damage(damage)


func _on_hp_death():
	off()
