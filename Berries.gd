extends Area2D

var hp_restored = 100

func _on_body_entered(body):
	if body.has_method("player"):
		if Global.player_health < 100: #check if player needs fruit. something going wrong here
			Global.berry_interact = Global.berry_interact + 1 
		#if Global.gem_interact == 1 & Global.player_health <= 85:
			#it is breaking after the if statement above.. making it just restore player hp to full for now
			#Global.player_health = Global.player_health + hp_restored 
			print("global hp before: ", Global.player_health)
			Global.player_health = hp_restored
			print("global health after: ", Global.player_health)
			queue_free() 

#work on making restore 15 later just restores to 100 for now 
#Restores health fine, yet hp bar does not update properly
