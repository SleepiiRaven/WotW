extends Popup

var npc
var npc_name setget name_set
var dialogue setget dialogue_set

func ready():
	set_process_input(false)

func name_set(new_value):
	npc_name = new_value
	$TextureRect/NPCName.text = new_value

func dialogue_set(new_value):
	dialogue = new_value
	$TextureRect/Dialogue.text = new_value

func open():
	get_tree().paused = true
	popup()
	$AnimationPlayer.playback_speed = 60/dialogue.length()
	$AnimationPlayer.play("ShowDialogue")

func close():
	get_tree().paused = false
	hide()

func _on_AnimationPlayer_animation_finished(anim_name):
	npc.set_process_input(true)
