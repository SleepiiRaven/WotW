extends Node2D

func _on_Forest_body_entered(body):
	if body.name == "Player":
		print("Teleported!")
		#fade to black, teleport to new area
