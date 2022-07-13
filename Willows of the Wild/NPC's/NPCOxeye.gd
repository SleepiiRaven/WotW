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
var monsters_killed = 0

onready var dialoguePopup = get_tree().get_root().get_node("World/CanvasLayer/DialogPopup")
onready var player = get_tree().get_root().get_node("World/YSort/Player")
onready var oakie = get_tree().get_root().get_node("World/YSort/NPCs/NPCOakie")
onready var canvas = get_tree().get_root().get_node("World/CanvasLayer")

func _input(event):
	if event.is_action_pressed("interact") && player_in_range:
		set_process_input(false)
		talk()

func talk():
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Oxeye"
	
	#Dialogue

	match quest1_status:
		questStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Don't go in there. There are m-monsters-"
					dialoguePopup.open()
				1:
					dialogue_state = 2
					dialoguePopup.dialogue = "What? You want to go in?"
					dialoguePopup.open()
				2:
					dialogue_state = 3
					dialoguePopup.dialogue = "Okay, kill 20 monsters in there, and you'll be rewarded."
					dialoguePopup.open()
				3:
					dialogue_state = 0
					quest1_status = questStatus.STARTED
					dialoguePopup.close()
					set_process_input(true)
					oakie.found_child = true
		questStatus.STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Did you kill all of them?"
					dialoguePopup.open()
				1:
					if monsters_killed == 20:
						dialogue_state = 2
						dialoguePopup.dialogue = "Thanks!"
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "AVENGE ME."
						dialoguePopup.open()
				2:
					dialogue_state = 0
					quest1_status = questStatus.COMPLETED
					dialoguePopup.close()
					set_process_input(true)
					#gain rewards
				3:
					dialogue_state = 0
					dialoguePopup.close()
					set_process_input(true)

		questStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Hey! Thanks for avenging me."
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					set_process_input(true)


func open_dialogue(dialogue, next_state):
	dialogue_state = next_state
	dialoguePopup.dialogue = dialogue
	dialoguePopup.open()

func close_dialogue():
	dialogue_state = 0
	dialoguePopup.close()
	set_process_input(true)

func _on_CheckPlayer_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_CheckPlayer_body_exited(body):
	if body.name == "Player":
		player_in_range = false
