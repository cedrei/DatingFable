extends Control

"""
For testing purposes, to be able to load any scene in the game
"""



func list_files_in_directory(path):
	# Function stolen from the internet...
	# Gets an array of all the file names in a folder
	# Thus, we can list all the files in the /levels folder.
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(file)

    dir.list_dir_end()

    return files

func _ready():
	# Get all the levels
	var cutscene_files = list_files_in_directory("res://levels")
	var level_loader_option = load("res://scenes/LevelLoaderOption.tscn")
	
	# Get all UI screens
	var ui_screens = get_tree().get_root().get_node("Root/UI").get_children()
	
	# Get all scenes
	var scenes = list_files_in_directory("res://scenes")
	# Loop through them. For each, make an instance of the
	# level_loader_option scene, and give it the right name.
	for file_name in cutscene_files:
		if file_name.substr(file_name.length()-3,3) != "txt":
			continue
		var node = level_loader_option.instance()
		node.set_path(file_name, "cutscene")
		get_node("Background/ScrollContainer/HBoxContainer/VBoxContainer").add_child(node)
	
	for screen in ui_screens:
		var node = level_loader_option.instance()
		node.set_path(screen.name, "ui")
		get_node("Background/ScrollContainer/HBoxContainer/VBoxContainer2").add_child(node)
	
	for file_name in scenes:
		if file_name.substr(file_name.length()-4,4) != "tscn":
			continue
		var node = level_loader_option.instance()
		node.set_path(file_name, "scene")
		get_node("Background/ScrollContainer/HBoxContainer/VBoxContainer3").add_child(node)