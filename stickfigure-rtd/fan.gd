extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimatedSprite2D.play()


func _on_body_entered(body: Node2D) -> void:
	# make the ball fly away as if blown by a fan
		
	# check if the body entered has a push back method
	if "push_back" in body:
		body.push_back()	
	
