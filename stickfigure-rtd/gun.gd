extends Node2D

var Bullet = preload("res://bullet.tscn")

signal shoot(bullet)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func fire():
	shoot.emit(Bullet, global_position)
