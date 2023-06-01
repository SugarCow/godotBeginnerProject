extends CharacterBody2D


const SPEED = 200

var JUMP_VELOCITY = -300


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_crouched = false
var increased_jump = false

@onready var anim = get_node("AnimatedSprite2D")

func _physics_process(delta):
	if increased_jump == false:
		JUMP_VELOCITY = -300

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if increased_jump == true:  # if the player is crouched then increased jump will be enabled
			JUMP_VELOCITY = -600
		is_crouched = false
			
		velocity.y = JUMP_VELOCITY
		if velocity.y == JUMP_VELOCITY:
			anim.play("jump")
			
	if velocity.y > 0: 
		anim.play("fall")
	


	#handles crouch 
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		anim.play("crouch")
		is_crouched = true
		increased_jump = true # activates increased jump mode
	
	if Input.is_action_just_released("ui_down"):
		is_crouched = false
		increased_jump = false # deactiviates increased jump mode


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	if direction == 1:
		get_node("AnimatedSprite2D").flip_h = false


	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0: 
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and is_crouched == false: 
			anim.play("idle")
		
		if velocity.y == 0 and is_crouched == true:
			anim.play("crouch")
		
		if velocity.y == 0 and is_crouched == false and velocity.y > 0:
			anim.play("fall")
	


	move_and_slide()

	if Game.playerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
