extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player 
#var random_number
#var random_direction
var speed = 100
#var jump_cooldown = 60
#var jump_on_cooldown = false
var chase = false
var dying = false


func _ready():
	get_node("AnimatedSprite2D").play("idle")
func _physics_process(delta):
	#Gravity for Frog
	velocity.y += gravity * delta
	
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * speed
	else:
		if get_node("AnimatedSprite2D").animation != "death":
			get_node("AnimatedSprite2D").play("idle")
		velocity.x = 0
	move_and_slide()





#func _on_player_detection_body_entered(body):# detects if player entered the collision box


func _on_player_detection_body_entered(body):
	
	if body.name == "Player":
		chase = true
	
#			print(str(player.global_position))


func _on_player_detection_body_exited(body):
	
	if body.name == "Player":
		chase = false
#	get_node("AnimatedSprite2D").play("idle")
#	jump_cooldown = 0


func _on_die_body_entered(body):
	if body.name == "Player":
		death()
#		dying = true
#		get_node("AnimatedSprite2D").play("die")
#		await get_node("AnimatedSprite2D").animation_finished # wait for the death animation to finish
#		self.queue_free() # delete the object from the world
		

func death(): 
	Game.player_gold += 5
	Utils.save_game()
	
	chase = false
	get_node("AnimatedSprite2D").play("death")
	await get_node("AnimatedSprite2D").animation_finished
#	if !get_node("AnimatedSprite2D").animation fi
	self.queue_free()

#func _physics_process(delta):
#
#	#gravity for frog 
#	velocity.y += gravity + delta
#
#	random_number = randf_range(0,1)
#	if dying == false:
##		if random_number >= .997 and chase == false: # random patrolling
##			random_direction = randi_range(0,1)
##
##			if random_direction == 0:
##				random_direction = -1
##				get_node("AnimatedSprite2D").flip_h = false
##			if random_direction == 1:
##				get_node("AnimatedSprite2D").flip_h = true
##
##			velocity.x = random_direction * speed
##			get_node("AnimatedSprite2D").play("jump")
##			jump_on_cooldown = true
##
##
##		elif jump_cooldown <= 0: 
##			jump_cooldown = 60
##			jump_on_cooldown = false
##			velocity.x = 0
##			get_node("AnimatedSprite2D").play("idle")
##
##
##		if jump_on_cooldown == true:
##			jump_cooldown -=1
#
#
#
#		if chase == true: 
#			player = get_node("../../Player/Player")
#			var direction = (player.position - self.position).normalized()
#
#
#			if direction.x > 0: 
#				get_node("AnimatedSprite2D").flip_h = true
#				get_node("AnimatedSprite2D").play("jump")
#			else: 
#				get_node("AnimatedSprite2D").flip_h = false	
#				get_node("AnimatedSprite2D").play("jump")			
#			velocity.x = direction.x *  (speed + 20) # increased speed if chasing player
#
#		else:
#			get_node("AnimatedSprite2D").play("idle")
#
#	move_and_slide()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		Game.playerHp -= 3
		chase = false
		get_node("AnimatedSprite2D").play("death")
		await get_node("AnimatedSprite2D").animation_finished
	#	if !get_node("AnimatedSprite2D").animation fi
		self.queue_free()
