extends CharacterBody2D

var save_path = "user://variable.save"

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100 #if i change from 100, need to be careful of update_health() function down below.
var experience = 0
var exp_required = 100
var level = 0
var player_alive = true

#SAVE DATA
var loaded_experience = 0 
var loaded_level = 0
var loaded_health = 0

#GUI
@onready var expBar = get_node("GUILayer/GUI/%ExperienceBar")
@onready var lbllevel = get_node("GUILayer/GUI/ExperienceBar/%lbl_level")
@onready var levelPanel = get_node("GUILayer/GUI/LevelUp/%LevelUp")
@onready var upgradeOptions = get_node("GUILayer/GUI/LevelUp/UpgradeOptions")
@onready var itemOptions = preload("res://GUI/LevelUp/item_option.tscn")
@onready var sndLevelUp = get_node("GUILayer/GUI/LevelUp/snd_levelup")

var attack_ip = false #for animations

const speed = 100
var current_dir = "none"

func _ready():
	$CollisionShape2D/AnimatedSprite2D.play("front_idle") 
	load_data()


func _physics_process(delta):
	player_movement(false)
	enemy_attack()
	attack()
	current_camera()
	Global.player_health = health
	update_health()
	level_up()
	
	experience = Global.experience #get experience from Global
	set_expbar(experience, exp_required)
	
	if health <= 0:
		$CollisionShape2D/AnimatedSprite2D.play("death_2") #not working as intended.. works for now
		await $CollisionShape2D/AnimatedSprite2D.animation_finished
		#queue_free()
		player_alive = false #go back to menu or respawn
		health = 0
		print("player has been killed.")
		self.queue_free()

func player_movement(delta):
	
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		play_anim(1)
		current_dir = "left"
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		play_anim(1)
		current_dir = "down"
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("up"):
		play_anim(1)
		current_dir = "up"
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0) #not moving
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $CollisionShape2D/AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false 
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:    # cant be idling if we are attacking
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true 
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = true 
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true 
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")
			
			

	
func player():
	pass
	
func _on_player_hitbox_body_entered(body): #hitbox statements for combat
	if body.has_method("enemy"): 
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
	

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false #cant chain attack
		$attack_cooldown.start()
		print(health)

func _on_attackcooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir 
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$CollisionShape2D/AnimatedSprite2D.flip_h = false
			$CollisionShape2D/AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$CollisionShape2D/AnimatedSprite2D.flip_h = true #flip art to be facing left
			$CollisionShape2D/AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$CollisionShape2D/AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$CollisionShape2D/AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
			
			

func _on_deal_attack_timer_timeout(): # 4 frames in our front_attack frame. 8 frames per second. 
	$deal_attack_timer.stop()         # will take 1/2 a second to play all four. 
	Global.player_current_attack = false #when adding other weapons animations, reference this
	attack_ip = false

func current_camera():
	if Global.current_scene == "world":
			$world_camera.enabled = true
			$cliffside_camera.enabled = false

	elif Global.current_scene == "cliff_side":
			$world_camera.enabled = false
			$cliffside_camera.enabled = true

func update_health():
	var healthbar = $healthbar # might need player/healthbar or etc
	healthbar.value = health
	
	if health >= 100: # remove this if and else : if we want healthbar to be visible all the time
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health == 0:
		health = 0
		

func level_up(): #check to see if xp is >= 100
	if Global.experience >= exp_required:
		print("level up!")
		level = level + 1
		Global.experience = 0
		experience = 0
		levelup() 
		

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(experience) #store experience :o
	file.store_var(level)
	file.store_var(health)
	print("saved experience: ", experience)
	print("saved level: ", level)
	print("saved health: ", health)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		#Global.experience = file.get_var(experience)
		loaded_experience = file.get_var(experience)
		loaded_level = file.get_var(level)
		loaded_health = file.get_var(health)
		print("loaded experience :", loaded_experience)
		print("loaded level : ", loaded_level)
		print("loaded health : ", loaded_health)
	else:
		print("no data has been saved...")
		experience = 0
		level = 0
	

func _on_cliffside_save_body_entered(body):
	save()

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelup():
	sndLevelUp.play() #play lvl up sound
	print("current level: ", level)
	lbllevel.text = str("Level: ", level) #update level
	var tween = levelPanel.create_tween() #bring panel in from right
	tween.tween_property(levelPanel,"position",Vector2(500,110),0.6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play() #209 104
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true #pause everything in our tree
	#lblLevel.text = str("Level: " ,experience_level) use this when we can check for xp level

func upgrade_character(upgrade):
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	levelPanel.visible = false
	levelPanel.position = Vector2(800,50)
	get_tree().paused = false #unpause
	#calculate_experience(0) went here. I decided not to go calculate it somewhere else 
