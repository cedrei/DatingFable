extends Button

var level_name

func set_path(file_name):
	# Set the text of the button
	text = file_name
	var file_name_length = file_name.length() -4
	level_name = file_name.substr(0,file_name_length)

func _pressed():
	get_tree().get_root().get_node("Root").play_level(level_name)