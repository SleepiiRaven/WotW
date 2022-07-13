extends Control

var saved_scene

func _on_Button_pressed():
	saved_scene = get_tree().change_scene("res://World.tscn")

func _on_Button2_pressed():
	get_tree().quit()
