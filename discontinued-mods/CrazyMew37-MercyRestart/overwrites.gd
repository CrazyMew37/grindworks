extends Node

func _init():
	var overwrite_gameover = preload("res://mods-unpacked/CrazyMew37-MercyRestart/overwrites/lose_menu.tscn")
	overwrite_gameover.take_over_path("res://objects/player/ui/lose_menu.tscn")
