extends Button

func pressed():
	get_tree().get_root().get_node("Root").goto_menu("TitleScreen")