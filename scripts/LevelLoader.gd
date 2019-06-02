extends Control

"""
For testing purposes, to be able to load any scene in the game
"""

var level_loader_option = preload("res://scenes/LevelLoaderOption.tscn")

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
	var files = list_files_in_directory("res://levels")
	
	# Loop through them. For each, make an instance of the
	# level_loader_option scene, and give it the right name.
	for file_name in files:
		var node = level_loader_option.instance()
		node.set_path(file_name)
		get_node("Background/ScrollContainer/VBoxContainer").add_child(node)