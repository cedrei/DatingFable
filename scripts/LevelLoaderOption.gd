extends Button

func set_path(file_name):
	var file_name_length = file_name.length() - 4
	text = file_name.substr(0,file_name_length)