extends CanvasLayer

var glue = 0
var item1 = PlayerStats.item1
var item2 = PlayerStats.item2
var item3 = PlayerStats.item3

var basket = preload("res://Items/basket.png")

func _physics_process(_delta):
	$Currency/Label.text = "x" + str(glue)
	if item1 != null:
		set_item1(item1)
	if item2 != null:
		set_item2(item2)
	if item3 != null:
		set_item3(item3)
	
func set_item1(new_value):
	if new_value == "basket":
		$ItemSlot1.texture = basket
	PlayerStats.item1 = new_value

func set_item2(new_value):
	if new_value == "basket":
		$ItemSlot2.texture = basket
	PlayerStats.item2 = new_value

func set_item3(new_value):
	if new_value == "basket":
		$ItemSlot3.texture = basket
	PlayerStats.item3 = new_value
