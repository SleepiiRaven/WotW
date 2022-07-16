extends StaticBody2D

enum questStatus {
	NOT_STARTED, STARTED, COMPLETED
}

enum potion {
	HEALTH, 
	MANA
}

var player_in_range = false
var dialogue_state = 0
var given_glue = false

onready var dialoguePopup = get_tree().get_root().get_node("World/CanvasLayer/DialogPopup")
onready var player = get_tree().get_root().get_node("World/YSort/Player")
onready var canvas = get_tree().get_root().get_node("World/CanvasLayer")

func _input(event):
	if event.is_action_pressed("interact") && player_in_range:
		set_process_input(false)
		talk()

func talk():
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Blackberry"
	
	#Dialogue
	match dialogue_state:
		0:
			dialogue_state = 1
			dialoguePopup.dialogue = "Hey! Would you like one of my fabulous wares?"
			dialoguePopup.open()
		1:
			dialogue_state = 2
			dialoguePopup.dialogue = "Just walk up to the one you would like and press Z."
			dialoguePopup.open()
		2:
			dialogue_state = 3
			dialoguePopup.dialogue = "Try it if you'd like."
			dialoguePopup.open()
		3:
			dialogue_state = 0
			dialoguePopup.close()
			set_process_input(true)
		

func _on_CheckPlayer_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_CheckPlayer_body_exited(body):
	if body.name == "Player":
		player_in_range = false
