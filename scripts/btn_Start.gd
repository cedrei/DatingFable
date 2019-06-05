extends TextureButton

var image = preload("res://assets/buttons_titlescreen/play_game.png")

func _pressed():
	# goto charcreation
	get_tree().get_root().get_node("Root").goto_menu("char-creation")

func _ready():
	# Create click mask
#	var bitmap = BitMap.new()
#	bitmap.create_from_image_alpha(image)
#	texture_click_mask = bitmap
	var bitmap = BitMap.new()
	bitmap.create(Vector2(300,100))
	#bitmap.set_bit_rect(Rect2(Vector2(0,0),Vector2(300,100)),true)
#	texture_click_mask = bitmap