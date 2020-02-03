extends Node

signal input_recieved(input)

func _input(event):
	emit_signal("input_recieved", event)
	
func _on_interceptor_input_recieved(event):
	get_tree().input_event(event)
