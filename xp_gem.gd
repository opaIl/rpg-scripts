extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.has_method("player"):
		Global.gem_interact = Global.gem_interact + 1
		print("gem interact value : ", Global.gem_interact)
		if Global.gem_interact == 1:
			Global.experience += 50
			#$XpGem.visible = false       same with line below
			queue_free() #need to figure out how to hide sprite 


#could have different abilities for berries once I add an inventory system... 
#would need to add multiple different classes 

#red > instant hp recovery 
#blue > hp regen ?
#yellow > speed increase 
#purple > atk damage boost 
