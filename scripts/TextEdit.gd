extends TextEdit

var full_string = ""
var time = 0

func print_dialogue(string):
	full_string = string
	time = 0

func _process(delta):
	var time_per = pow(100-get_tree().get_root().get_node("Root").settings.text_speed, 2) / 100000
	if time_per == 0:
		write_all()
		return
	if not get_parent().get_parent().printing:
		return
	time += delta
	text = full_string.substr(0,ceil(time/time_per))
	if ceil(time/time_per) >= full_string.length():
		get_parent().get_parent().printing = false

func write_all():
	text = full_string
	get_parent().get_parent().printing = false