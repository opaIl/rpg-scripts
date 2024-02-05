extends Node2D

var experience = Global.experience

func _process(delta):
	change_scenes()

func _on_cliffside_exitpoint_body_entered(body):
	if body.has_method("player"):
		#var game_first_loadin = true
		Global.transition_scene = true


func _on_cliffside_exitpoint_body_exited(body):
	if body.has_method("player"):
		Global.transition_scene = false
		print("cliffside xp ", experience)

func change_scenes():
	if Global.transition_scene == true:
		if Global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			Global.finish_changescenes()
