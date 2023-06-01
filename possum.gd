
extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player 
var random_number
var random_direction
var speed = 100
var change_direction_timer = 150

var direction = -1
var chase = false

func _ready():
	get_node("AnimatedSprite2D").play("walk")

func _physics_process(delta):
	
	#gravity for possum
	velocity.y += gravity + delta

	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction == 1:
		get_node("AnimatedSprite2D").flip_h = true
	if chase == true:  #chase mode
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()


		if direction.x > 0: 
			get_node("AnimatedSprite2D").flip_h = true
			
		else: 
			get_node("AnimatedSprite2D").flip_h = false	
		
		if get_node("AnimatedSprite2D").animation != "death":
			
			get_node("AnimatedSprite2D").play("walk")			
		
		velocity.x = direction.x *  (speed + 20) # increased speed if chasing player

	else: # patrol mode
		velocity.x = direction * speed
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("walk")

		if change_direction_timer > 0:
			change_direction_timer -= 1

		else:
			direction = direction * -1
			var node = get_node("DetectPlayer/CollisionShape2D")
			node.rotation_degrees += 180
			change_direction_timer = 150



	move_and_slide()






func _on_die_body_entered(body):
	if body.name == "Player":
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished # wait for the death get_node("AnimatedSprite2D")ation to finish
		self.queue_free() # delete the object from the world
		


func _on_detect_player_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_detect_player_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_hurt_player_body_entered(body):
	if body.name == "Player":
		Game.playerHp -= 3
		chase = false
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished
	#	if !get_node("AnimatedSprite2D").animation fi
		self.queue_free()
