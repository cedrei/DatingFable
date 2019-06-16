extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_root():
	return get_tree().get_root().get_node("Root")

func _on_HSlider_value_changed(value):
	get_root().settings.music_volume = value
	get_root().update_music_volume()

func _on_HSlider2_value_changed(value):
	get_root().settings.sfx_volume = value

func _on_HSlider3_value_changed(value):
	get_root().settings.text_speed = value
