extends Node3D

@onready var eventbus = get_node_or_null("/root/EventBus")

func _ready():
	goat_interaction.connect("object_activated", self._on_oa)
	if eventbus:
		eventbus.connect("demo_event", self._on_demo_event)

func _on_oa(object_name, _point):
	if object_name == "open_2_minute_adventure":
		goat_voice.prevent_default()
		get_tree().change_scene_to_file("res://demo/scenes/main/Gameplay.tscn")
	elif object_name == "npc_demo":
		DialogueManager.start_dialogue(load("res://demo/dialogues/npc_demo.dialogue"))
	elif object_name == "key_demo":
		goat_inventory.add_item("key_demo")
		if eventbus:
			eventbus.emit_demo_event("Ключ добавлен в инвентарь!")
	elif object_name == "terminal_demo":
		if eventbus:
			eventbus.emit_demo_event("Терминал активирован!")

func _on_demo_event(data):
	print("[EventBus] Глобальное событие:", data)
