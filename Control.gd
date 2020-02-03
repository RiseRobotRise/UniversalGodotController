extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var popup
	$VBoxContainer/Button.connect("pressed",self, "press")
func press():
	$VBoxContainer/Popup.popup_centered()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
