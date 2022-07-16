extends Node2D

var saved_scene 

func _on_Forest_body_entered(body):
	if body.name == "Player":
		$Fade.play("Fade")

func _on_Fade_animation_finished(anim_name):
	if anim_name == "Fade":
		saved_scene = get_tree().change_scene("res://Levels/StartingLevelA.tscn")
