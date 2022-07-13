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
var quest2_status = questStatus.NOT_STARTED
var dialogue_state = 0
var talked_to_oakie = false
var found_slimeball = false
var placeholder_dialog_var = false

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
	dialoguePopup.npc_name = "Hyacinth"
	
	#Dialogue
	#During Oakie's Quest
	if oakie.quest1_status == questStatus.STARTED:
		match quest1_status:
			questStatus.NOT_STARTED:
				match dialogue_state:
					0:
						dialogue_state = 1
						dialoguePopup.dialogue = "Oh god!"
						dialoguePopup.open()
					1:
						dialogue_state = 2
						dialoguePopup.dialogue = "Oakie's gonna be so mad at me..."
						dialoguePopup.open()
					2:
						dialogue_state = 3
						dialoguePopup.dialogue = "I'll go back, sorry about that."
						dialoguePopup.open()
					3:
						dialogue_state = 0
						quest1_status = questStatus.COMPLETED
						dialoguePopup.close()
						set_process_input(true)
						oakie.found_child = true
			questStatus.COMPLETED:
				match dialogue_state:
					0:
						dialogue_state = 1
						dialoguePopup.dialogue = "You should go talk to Oakie, they're waiting for you."
						dialoguePopup.open()
					1:
						dialogue_state = 0
						dialoguePopup.close()
						set_process_input(true)
	#Before Oakie's Quest
	elif oakie.quest1_status == questStatus.NOT_STARTED:
		match dialogue_state:
			0:
				dialogue_state = 1
				dialoguePopup.dialogue = "Heya! I'm playing slimeball!"
				dialoguePopup.open()
			1:
				dialogue_state = 2
				dialoguePopup.dialogue = "You can't play though 'cuz you're too big..."
				dialoguePopup.open()
			2:
				dialogue_state = 0
				dialoguePopup.close()
				set_process_input(true)
	#After Oakie's Quest
	elif oakie.quest1_status == questStatus.COMPLETED:
		match quest2_status:
			questStatus.NOT_STARTED:
				match dialogue_state:
					0:
						dialogue_state = 1
						dialoguePopup.dialogue = "Oakie took away my slimeball..."
						dialoguePopup.open()
					1:
						dialogue_state = 2
						dialoguePopup.dialogue = "Do you mind getting them to give it back?"
						dialoguePopup.open()
					2:
						dialogue_state = 0
						dialoguePopup.close()
						set_process_input(true)
						quest2_status = questStatus.STARTED
			questStatus.STARTED:
				if !found_slimeball && !placeholder_dialog_var:
					match dialogue_state:
						0:
							if talked_to_oakie == true:
								dialogue_state = 2
							else:
								dialogue_state = 1
							dialoguePopup.dialogue = "Did you talk to Oakie?"
							dialoguePopup.open()
						1:
							dialogue_state = 3
							dialoguePopup.dialogue = "Do you mind getting them to give it back?"
							dialoguePopup.open()
						2:
							dialogue_state = 4
							dialoguePopup.dialogue = "UGH. I have to do MORE chores? Tell them I'm on it..."
							dialoguePopup.open()
						3:
							dialogue_state = 0
							dialoguePopup.close()
							set_process_input(true)
						4:
							dialogue_state = 0
							dialoguePopup.close()
							set_process_input(true)
							placeholder_dialog_var=true
				elif !found_slimeball && talked_to_oakie:
					match dialogue_state:
						0:
							dialogue_state = 1
							dialoguePopup.dialogue = "Did you tell Oakie?"
							dialoguePopup.open()
						1:
							dialogue_state = 2
							dialoguePopup.dialogue = "Please tell them that I'm doing my chores."
							dialoguePopup.open()
						2:
							dialogue_state = 0
							dialoguePopup.close()
							set_process_input(true)
				elif !found_slimeball:
					match dialogue_state:
						0:
							dialogue_state = 1
							dialoguePopup.dialogue = "Did you ask for my slimeball?"
							dialoguePopup.open()
						1:
							dialogue_state = 2
							dialoguePopup.dialogue = "Please do so."
							dialoguePopup.open()
						2:
							dialogue_state = 0
							dialoguePopup.close()
							set_process_input(true)
				else:
					match dialogue_state:
						0:
							dialogue_state = 1
							dialoguePopup.dialogue = "Oh! Great, thanks! I still have to do chores?... UGH"
							dialoguePopup.open()
						1:
							dialogue_state = 0
							dialoguePopup.close()
							canvas.glue += 10
							canvas.get_node("Currency/AudioStreamPlayer").play()
							canvas.get_node("ItemSlimeball").visible = false
							quest2_status = questStatus.COMPLETED
							set_process_input(true)
					
			questStatus.COMPLETED:
				match dialogue_state:
					0:
						dialogue_state = 1
						dialoguePopup.dialogue = "Heya! Thanks so much about that earlier."
						dialoguePopup.open()
					1:
						dialogue_state = 2
						dialoguePopup.dialogue = "I really do appreciate it, sorry for being moody."
						dialoguePopup.open()
					2:
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
