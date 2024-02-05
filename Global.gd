extends Node

var player_current_attack = false #global means we can access from any script. Project settings > autoload

var current_scene = "world" #or new cliffside scene
var transition_scene = false 

var player_exit_cliffside_posx = 165
var player_exit_cliffside_posy = 20
var player_start_posx = 21
var player_start_posy = 36

var player_health = 0
var player_speed = 60
var experience = 0

var game_first_loadin = true

#item interactions
var gem_interact = 0
var berry_interact = 0

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene =="world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"

