extends Area2D

var speed_boost = 200

func _on_body_entered(body):
	if body.has_method("player"):
			Global.berry_interact = Global.berry_interact + 1 
			print("global spd before: ", Global.player_speed)
			Global.player_speed = Global.player_speed + speed_boost
			print("global spd after: ", Global.player_speed)
			Global.berry_interact = 0
			queue_free() 

func _on_timer_timeout():
	Global.player_speed = 60 #change speed after 2 seconds. change this later if can upgrade speed..
	print("timeout")
