extends Node

const CONFIG_PATH := "user://SaveData.cfg"

var levelsLibrary = LevelsManager.levelsLibrary

signal saveDataSaved
signal saveDataLoaded
signal saveDataDeleted

func _init() -> void:
	load_save()

func save_game():
	var config = ConfigFile.new()
	var now = Time.get_datetime_dict_from_system()
	var config_save_time = "%02d/%02d/%04d - %02d:%02d" % [now.day, now.month, now.year, now.hour, now.minute]
	var reached_level = LevelsManager.reached_level
	for level in levelsLibrary.keys():
		var section = "Level" + str(level)
		config.set_value(section, "isLevelCleared", levelsLibrary[level]["isLevelCleared"])
		config.set_value(section, "HighScore", levelsLibrary[level]["HighScore"])
	config.set_value("Meta", "save_time", config_save_time)
	config.set_value("Meta", "reached_level", reached_level)
	config.save(CONFIG_PATH)
	print("Game saved to: " + CONFIG_PATH + " Reached level: " + str(reached_level))
	emit_signal("saveDataSaved")

func load_save():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err != OK:
		print("No save file found at: " + CONFIG_PATH)
		return # No file yet, skip
	LevelsManager.reached_level = config.get_value("Meta", "reached_level", 0)
	for level in levelsLibrary.keys():
		var section = "Level" + str(level)
		if config.has_section(section):
			levelsLibrary[level]["isLevelCleared"] = config.get_value(section, "isLevelCleared", false)
			levelsLibrary[level]["HighScore"] = config.get_value(section, "HighScore", 0)
	print("Save loaded from: " + CONFIG_PATH + " from " + config.get_value("Meta", "save_time", "") + " Reached level: " + str(LevelsManager.reached_level))
	emit_signal("saveDataLoaded")

func delete_save():
	if FileAccess.file_exists(CONFIG_PATH):
		var dir = DirAccess.open("user://")
		if dir:
			LevelsManager.reached_level = 0
			dir.remove("SaveData.cfg")
			print("Save file deleted: " + CONFIG_PATH)
			emit_signal("saveDataDeleted")
		else:
			print("Could not open user directory to delete save file.")
	else:
		print("No save file to delete at: " + CONFIG_PATH)
