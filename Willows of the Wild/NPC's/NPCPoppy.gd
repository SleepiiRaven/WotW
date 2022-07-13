extends StaticBody2D

enum questStatus {
	NOT_STARTED, STARTED, COMPLETED
}

enum potion {
	HEALTH, 
	MANA
}

var player_in_range = false
var quest1_status = questStatus.NOT_STARTED
var dialogue_state = 0
var found_banana = false

onready var dialoguePopup = get_tree().get_root().get_node("World/CanvasLayer/DialogPopup")
onready var player = get_tree().get_root().get_node("World/YSort/Player")
onready var canvas = get_tree().get_root().get_node("World/CanvasLayer")

func _input(event):
	if event.is_action_pressed("interact") && player_in_range:
		set_process_input(false)
		talk()

func talk():
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Poppy"
	
	#Dialogue
	match quest1_status:
		questStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Hey, Leaf. I'm hungry."
					dialoguePopup.open()
				1:
					dialogue_state = 2
					dialoguePopup.dialogue = "I left my banana in the woods."
					dialoguePopup.open()
				2:
					dialogue_state = 3
					dialoguePopup.dialogue = "Get it for me."
					dialoguePopup.open()
				3:
					dialogue_state = 0
					quest1_status = questStatus.STARTED
					dialoguePopup.close()
					set_process_input(true)
		questStatus.STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Do you have the banana?"
					dialoguePopup.open()
				1:
					if found_banana == true:
						dialogue_state = 2
						dialoguePopup.dialogue = "Gimme."
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "Go find it."
						dialoguePopup.open()
				2:
					#give rewards
					dialogue_state = 0
					quest1_status = questStatus.COMPLETED
					$Sprite.visible = true
					get_tree().get_root().get_node("World/CanvasLayer/ItemBanana").visible = false
					canvas.glue += 15
					canvas.get_node("Currency/AudioStreamPlayer").play()
					dialoguePopup.close()
					set_process_input(true)
				3:
					dialogue_state = 0
					dialoguePopup.close()
					set_process_input(true)
		questStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "OM NOM NOM"
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					set_process_input(true)

func _on_CheckPlayer_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_CheckPlayer_body_exited(body):
	if body.name == "Player":
		player_in_range = false
