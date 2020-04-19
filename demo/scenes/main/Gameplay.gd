extends Spatial

onready var animation_player = $AnimationPlayer


func _ready():
	goat_inventory.reset()
	goat_voice.reset()
	demo.reset()
	
	# Configure GoatVoice
	var audio_to_transcript := {
		"just_a_few_steps":
			"Just a few steps more and I will open the portal!",
		"power_it_up_first":
			"I should power it up first.",
		"pizza_eaten":
			"Mmmm, delicious!",
		"useless_without_battery":
			"It's useless without a battery.",
		"upload_coords_first":
			"I should upload the coordinates first.",
		"finally_active":
			"The portal is active! Almost there...",
		"coords_uploaded":
			"The coordinates are uploaded. Now, where is the remote...",
		"eat_something_first":
			"It's going to be a long journey, I should eat something first.",
		"another_world_awaits":
			"Finally! This is actually happening! Another world awaits!",
		# Defaults
		"but_why": "But why?",
		"what_for": "What for?",
		"this_doesnt_make_sense": "This doesn't make sense...",
	}
	
	for audio_name in audio_to_transcript:
		goat_voice.register(audio_name, audio_to_transcript[audio_name])
	
	# Voice without audio, with forced duration for subtitles
	goat_voice.register(
		"better_way", "There should be a better way of using it...", 5
	)
	
	goat_voice.set_default_audio_names(
		["but_why", "what_for", "this_doesnt_make_sense"]
	)
	
	# Configure Gameplay
	demo.connect("portal_entered", animation_player, "play", ["end_game"])
	animation_player.connect("animation_finished", self, "animation_finished")
	
	animation_player.play("start_game")
	goat_voice.play("just_a_few_steps")


func animation_finished(animation_name):
	if animation_name == "end_game":
		get_tree().change_scene("res://demo/scenes/main/Credits.tscn")
