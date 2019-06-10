extends Button

var level_name
var type

func set_path(button_name, button_type):
	# Set the type of the button
	type = button_type
	var file_name_length
	
	# Remove file endings
	match button_type:
		"cutscene":
			file_name_length = button_name.length() -4
		"ui":
			file_name_length = button_name.length()
		"scene":
			file_name_length = button_name.length() -5
	level_name = button_name.substr(0,file_name_length)
	# Set the text
	text = level_name

func _pressed():
	match type:
		"cutscene":
			get_tree().get_root().get_node("Root").play_level(level_name)
		"ui":
			get_tree().get_root().get_node("Root").goto_menu(level_name)
		"scene":
			get_tree().get_root().get_node("Root").play_scene(level_name)
	