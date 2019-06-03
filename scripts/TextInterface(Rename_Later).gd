extends Control

func dialogue(dialogue):
	$TextDisplay/TextEdit.text = ""
	$ClickAnywhereToContinue.is_listening = true
	for word in dialogue:
		$TextDisplay/TextEdit.text += word + " "

func continue_script():
	get_tree().get_root().get_node("Root").continue_script()