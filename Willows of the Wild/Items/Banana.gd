extends Area2D

onready var poppy = get_tree().get_root().get_node("World/YSort/NPCs/NPCPoppy")

func ready():
	print(poppy)


func _on_Banana_body_entered(body):
	if body.name == "Player":
		queue_free()
		poppy.found_banana = true
		get_tree().get_root().get_node("World/CanvasLayer/Currency/AudioStreamPlayer").play()
		get_tree().get_root().get_node("World/CanvasLayer/ItemBanana").visible = true
