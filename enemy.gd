extends CharacterBody2D

var speed = 60
var player_chase = false
var player = null

var health = 100
var player_inattack_zone = false
var can_take_damage = true
var player_health
var experience = 0

 #var startup = player.position
# slime chases origin of player so i need to tell slime the characters fixed origin in beginning. do later

func _physics_process(delta):
	deal_with_damage() #call method from bottom
	update_health()
	
	player_health = Global.player_health
	reset()
	
	if player_chase:
		position += (player.position - position)/speed
		move_and_collide(Vector2(0,0))
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else: 
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body): #when player enters zone, chase
	player = body #whatever enters the zone
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ",health)
			if health <= 0:
				print("slime has been killed")
				experience = experience + 25
				Global.experience = Global.experience + experience
				print("experience gained: ", experience)
				print("global xp: ", Global.experience)
				self.queue_free() #need this or memory leak

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		
func reset(): #call after player health = 0   
	if player_health <= 0:                    
		position += ($resetpos.position - position)/speed #- should be default makes mob back off.
		#print(position.y, position.x)                     
		$AnimatedSprite2D.play("walk")
		#if($resetpos.position.x - position.x) < 0:
		#	$AnimatedSprite2D.flip_h = true
		#else: 
		#	$AnimatedSprite2D.flip_h = false
	#else:
		#$AnimatedSprite2D.play("idle")





