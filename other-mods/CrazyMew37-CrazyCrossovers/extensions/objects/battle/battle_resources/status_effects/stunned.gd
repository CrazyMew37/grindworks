@tool
extends StatusEffect

func apply() -> void:
	var cog: Cog = target
	manager.skip_turn(cog)
	cog.stunned = true

func get_description() -> String:
	var return_string := "This cog is unable to attack."
	return return_string

func expire() -> void:
	target.stunned = false

func get_status_name() -> String:
	return "Stunned"

func get_icon() -> Texture2D:
	return load("res://mods-unpacked/CrazyMew37-CrazyCrossovers/extensions/ui_assets/battle/statuses/stunnedeffect.png")
