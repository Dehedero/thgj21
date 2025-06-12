extends Node

signal demo_event(data)

func emit_demo_event(data):
	emit_signal("demo_event", data)
