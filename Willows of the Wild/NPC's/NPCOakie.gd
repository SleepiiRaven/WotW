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
var found_child = false

onready var dialoguePopup = get_tree().get_root().get_node("World/CanvasLayer/DialogPopup")
onready var player = get_tree().get_root().get_node("World/YSort/Player")
onready var canvas = get_tree().get_root().get_node("World/CanvasLayer")
onready var hyacinth = get_tree().get_root().get_node("World/YSort/NPCs/NPCHyacinth")

func _input(event):
	if event.is_action_pressed("interact") && player_in_range:
		set_process_input(false)
		talk()

func talk():
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Oakie"
	
	#Dialogue
	if hyacinth.quest2_status == questStatus.STARTED:
		if !hyacinth.talked_to_oakie:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Hyacinth wants their- toy?- back?"
					dialoguePopup.open()
				1:
					dialogue_state = 2
					dialoguePopup.dialogue = "Well, tell them they need to do their chores first."
					dialoguePopup.open()
				2:
					dialogue_state = 0
					hyacinth.talked_to_oakie = true
					dialoguePopup.close()
					set_process_input(true)
		else:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "They're doing their chores? Okay, fine..."
					dialoguePopup.open()
				1:
					dialogue_state = 2
					dialoguePopup.dialogue = "I'll give them their slimeball back."
					dialoguePopup.open()
				2:
					dialogue_state = 3
					dialoguePopup.dialogue = "But tell them they can't play 'till they finish."
					dialoguePopup.open()
				3:
					dialogue_state = 0
					hyacinth.found_slimeball = true
					canvas.get_node("ItemSlimeball").visible = true
					canvas.get_node("Currency/AudioStreamPlayer").play()
					dialoguePopup.close()
					set_process_input(true)
	else:
		match quest1_status:
			questStatus.NOT_STARTED:
				match dialogue_state:
					0:
						dialogue_state = 1
						dialoguePopup.dialogue = "Hey, Leaf, it's been a bit!"
						dialoguePopup.open()
					1:
						dialogue_state = 2
						dialoguePopup.dialogue = "I lost Hyacinth, my baby..."
						dialoguePopup.open()
					2:
						dialogue_state = 3
						dialoguePopup.dialogue = "Do you mind looking for them?"
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
						dialoguePopup.dialogue = "Hey Leaf!"
						dialoguePopup.open()
					1:
						if found_child == true:
							dialogue_state = 2
							dialoguePopup.dialogue = "Oh you found Hyacinth! Thanks so much. Here's a reward."
							dialoguePopup.open()
						else:
							dialogue_state = 3
							dialoguePopup.dialogue = "Did you find them?"
							dialoguePopup.open()
					2:
						#give rewards
						dialogue_state = 0
						quest1_status = questStatus.COMPLETED
						canvas.glue += 15
						canvas.get_node("Currency/AudioStreamPlayer").play()
						dialoguePopup.close()
						set_process_input(true)
					3:
						dialogue_state = 4
						dialoguePopup.dialogue = "Oh... please find my baby"
						dialoguePopup.open()
					4:
						dialogue_state = 0
						dialoguePopup.close()
						set_process_input(true)
			questStatus.COMPLETED:
				match dialogue_state:
					0:
						dialogue_state = 1
						dialoguePopup.dialogue = "They scared me half to death... Kids these days."
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
