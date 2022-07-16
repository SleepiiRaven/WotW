extends Area2D

var player_in_range = false
var dialogue_state = 0
var given_glue = false
var cost = 40

onready var canvas = get_tree().get_root().get_node("World/CanvasLayer")

func _input(event):
	if event.is_action_pressed("interact") && player_in_range:
		if PlayerStats.glue >= cost:
			canvas.glue -= cost
			PlayerStats.glue -= cost
			canvas.get_node("Currency/AudioStreamPlayer").play()
			print("ello chap")
			if str(canvas.item1) != "Null":
				print("hi")
				PlayerStats.item1 = "basket"
				canvas.item1 = "basket"
			elif canvas.item2 != null:
				PlayerStats.item2 = "basket"
				canvas.item2 = "basket"
			elif canvas.item3 != null:
				PlayerStats.item3 = "basket"
				canvas.item3 = "basket"
			queue_free()
		


func _on_Basket_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_Basket_body_exited(body):
	if body.name == "Player":
		player_in_range = false
