extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	goat.reset_game()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Play_pressed():
	get_tree().change_scene_to_file("res://game/scenes/main/Gameplay.tscn")


func _on_Settings_pressed():
	$Settings.show()
