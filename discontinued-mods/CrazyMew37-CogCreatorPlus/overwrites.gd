extends Node

func _init():
	var overwrite_creator = preload("res://mods-unpacked/CrazyMew37-CogCreatorPlus/overwrites/cog_creator.tscn")
	overwrite_creator.take_over_path("res://scenes/cog_creator/cog_creator.tscn")
