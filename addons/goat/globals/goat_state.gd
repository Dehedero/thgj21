extends Node

signal changed(variable_name, from_value, to_value)

var _variables := {}


func _register_all_variables() -> void:
	_register_variable("power_on", false)
	_register_variable("floppy_inserted", false)
	_register_variable("portal_status", "not_ready")
	_register_variable("battery_inserted", false)
	_register_variable("food_eaten", false)
	_register_variable("intro_played", false)


func _init():
	print("DEBUG: goat_state.gd loaded")
	_register_all_variables()
	_load()


func _ready():
	print("DEBUG: goat_state.gd _ready start")
	_register_all_variables()
	# TODO: load saved game from file
	var state_directory = goat.get_game_resources_directory() + "/goat/state/"
	var files = goat_utils.list_directory(state_directory)
	for file in files:
		if file.ends_with(".json"):
			var test_json_conv = JSON.new()
			test_json_conv.parse(goat_utils.load_text_file(state_directory + file))
			var data = test_json_conv.get_data()
			for key in data:
				_register_variable(key, data[key])
	print("DEBUG: goat_state.gd _ready end")


func _register_variable(variable_name: String, initial_value) -> void:
	_variables[variable_name] = initial_value


func get_value(variable_name: String):
	if not (variable_name in _variables):
		print("ERROR: Variable not registered: ", variable_name)
		assert(false)
	return _variables[variable_name]


func set_value(variable_name: String, value) -> void:
	assert(variable_name in _variables)
	var previous_value = _variables[variable_name]
	_variables[variable_name] = value
	emit_signal("changed", variable_name, previous_value, value)


func reset() -> void:
	_variables = {}
	_register_all_variables()
	_load()


func has_variable(variable_name: String) -> bool:
	return variable_name in _variables


func _load() -> void:
	# TODO: implement loading logic if needed
	pass
