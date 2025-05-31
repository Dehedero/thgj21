extends Node3D

@onready var animation_player = $AnimationPlayer


func _ready():
	print("DEBUG: Gameplay _ready start")
	# Configure Gameplay
	goat_state.connect("changed", self._on_game_state_changed)
	animation_player.connect("animation_finished", self.animation_finished)

	if not goat_state.get_value("intro_played"):
		print("DEBUG: Gameplay starting intro sequence")
		animation_player.play("start_game")
		print("DEBUG: Calling goat_voice.start_dialogue")
		goat_voice.start_dialogue("just_a_few_steps")
		print("DEBUG: goat_voice.start_dialogue returned")
		goat_state.set_value("intro_played", true)
	print("DEBUG: Gameplay _ready end")


func _on_game_state_changed(variable_name, _from_value, to_value):
	print("DEBUG: _on_game_state_changed called: ", variable_name, to_value)
	if variable_name == "portal_status" and to_value == "entered":
		animation_player.play("end_game")


func animation_finished(animation_name):
	print("DEBUG: animation_finished called: ", animation_name)
	if animation_name == "end_game":
		goat.game_mode = goat.GameMode.NONE
		get_tree().change_scene_to_file("res://demo/scenes/main/Credits.tscn")


func _process(delta):
	print("DEBUG: Gameplay _process")
