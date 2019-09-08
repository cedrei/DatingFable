extends Control

var item = preload("res://scenes/LogItem.tscn")

func load_log():
	# Remove the old log items
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	
	# Loop through the dialogue log array
	for dialogue in get_tree().get_root().get_node("Root").dialogue_log:
		# Load the name and dialogue to a LogItem scene, and add it to the VBoxContainer
		var instance = item.instance()
		instance.init(dialogue[0], dialogue[1])
		$ScrollContainer/VBoxContainer.add_child(instance)