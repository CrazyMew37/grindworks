extends Node
class_name CCglobal

var drenched_round_boost = 0
var sound_splash_boost = 0.0
var aftershock_damage_boost = 0.0

# Save function
func save_to():
	var CCSaveData = preload("res://mods-unpacked/CrazyMew37-CrazyCrossovers/CCSaveData.gd")
	var file_name = "CCcurrent_save.tres"
	
	var save_data = CCSaveData.new()
	save_data.drenched_round_boost = drenched_round_boost
	save_data.sound_splash_boost = sound_splash_boost
	save_data.aftershock_damage_boost = aftershock_damage_boost

	ResourceSaver.save(save_data, SaveFileService.SAVE_FILE_PATH + file_name)
	print("crazy crossovers saved to: ", SaveFileService.SAVE_FILE_PATH + file_name)
	
func load_save():
	print("loading crazy crossovers save")
	var file_path = SaveFileService.SAVE_FILE_PATH + "CCcurrent_save.tres"
	if FileAccess.file_exists(file_path):
		var loaded = ResourceLoader.load(file_path)
		if loaded:
			drenched_round_boost = loaded.drenched_round_boost
			sound_splash_boost = loaded.sound_splash_boost
			aftershock_damage_boost = loaded.aftershock_damage_boost
			print("crazy crossovers save loaded successfully")
		else:
			print("Failed to load crazy crossovers save file.")
	else:
		print("crazy crossovers save file not found")

func delete_save():
	print("deleting crazy crossovers save")
	var file_path = SaveFileService.SAVE_FILE_PATH + "CCcurrent_save.tres"
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)
		print("crazy crossovers save deleted")
	else:
		print("crazy crossovers save file not found")
	reset_stats()

func reset_stats():
	print("resetting crazy crossovers stats")
	drenched_round_boost = 0
	sound_splash_boost = 0.0
	aftershock_damage_boost = 0.0
