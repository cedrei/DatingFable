extends Node

func hide_menus():
	for node in $UI.get_children():
		node.visible = false

func goto_menu(name):
	hide_menus()
	$Viewport.visible = false
	match name:
		"title":
			$UI.TitleScreen.visible = true
		"level-loader":
			$UI.LevelLoader.visible = true

func show_interface():
	hide_menus()
	$UI/TextInterface.visible = true

func get_text_interface():
	return $UI/TextInterface

func _ready():
	show_interface()
	$Viewport.visible = true

func continue_script():
	$Viewport/BasicLevel.execute_next_command()