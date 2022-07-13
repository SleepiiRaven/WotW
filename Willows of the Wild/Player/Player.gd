extends KinematicBody2D

var acc = 500
var max_spd = 80
var fri = 600
var vel = Vector2.ZERO
var stored_input_vector = Vector2.ZERO
var slash_played = false

enum {
	MOVE,
	ATTACK
}

var state = MOVE

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
		ATTACK:
			attack()
			$Particles2D.emitting = false
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack():
	if stored_input_vector.y == 0:
		if !slash_played:
			$Slash.play()
			slash_played = true
		if $Slime.flip_h == true:
					$SlimeHand.position.x = -8
					$SlimeHand.visible = true
					$HandAnimation.play("SwingLeft")
		else:
			$SlimeHand.position.x = 8
			$SlimeHand.visible = true
			$HandAnimation.play("SwingRight")
	else:
		#swing up/down/diagonal
		state = MOVE

func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		$Particles2D.emitting = true
		$SlimeAnimation.play("Walk")
		$Particles2D.process_material.direction = Vector3(-input_vector.x, -input_vector.y, 0)
		
		
		vel = vel.move_toward(input_vector * max_spd, acc * delta)
		if input_vector.x > 0:
			$Slime.flip_h = false
			$SlimeHand.rotation_degrees = -60
		elif input_vector.x < 0:
			$Slime.flip_h = true
			$SlimeHand.rotation_degrees = -30
	else:
		$Particles2D.emitting = false
		$SlimeAnimation.stop()
		$Slime.frame = 0
		#animationState.travel("Idle")
		#make friction happen, moves your speed towards 0,0
		vel = vel.move_toward(Vector2.ZERO, fri * delta)

	stored_input_vector = input_vector

	move_and_slide(vel)

func _on_HandAnimation_animation_finished(anim_name):
	if anim_name == "SwingLeft" || anim_name == "SwingRight":
		$SlimeHand.visible = false
		$HandAnimation.play("RESET")
		state = MOVE
		slash_played = false
