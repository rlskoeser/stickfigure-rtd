extends Node

signal go

var lineup = []
var max_picks = 3

var ShieldGuy = preload("res://shield_guy.tscn")
var SwordGuy = preload("res://sword_guy.tscn")
var GunGuy = preload("res://gun_guy.tscn")
var FanGuy = preload("res://fan_guy.tscn")

var GuyResourceByName = {
	"ShieldGuy": ShieldGuy,
	"SwordGuy": SwordGuy,
	"GunGuy": GunGuy,
	"FanGuy": FanGuy
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# bind button press to handler and pass in the button
	for button in $Buttons.get_children():
		button.pressed.connect(on_button_press.bind(button))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_button_press(b) -> void:
	# first node under this button is the guy being picked
	var guy = b.get_children()[0]
	pick_guy(guy)
	#var pick_guy = guy.duplicate()
	#$Slot1.add_child(pick_guy)
	## button can't be used again
	b.set_disabled(true)
	
func pick_guy(guy):
	var count = lineup.size()
	# stop if we are at max
	if count >= max_picks:
		return
	
	# add resource for this guy to lineup by name
	lineup.append(GuyResourceByName[guy.name])
	# make a copy to put in the slot
	var chosen_guy = guy.duplicate()
	# TODO: make guy smaller?
	$Slots.get_children()[count].add_child(chosen_guy)
	
	# enable start button as soon as one guy is picked
	$GoButton.set_disabled(false)

func _on_go_button_pressed() -> void:
	go.emit(lineup)
