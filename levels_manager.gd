extends Node

@export var levelsLibrary: Dictionary = {
	0: {"scene": preload("res://Levels/level 0/level_0.tscn"), "isLevelCleared": false, "HighScore": 0, "isActive": false, "instance": null},
	1: {"scene": preload("res://Levels/level 1/level_1.tscn"), "isLevelCleared": false, "HighScore": 0, "isActive": false, "instance": null},
	2: {"scene": preload("res://Levels/level 2/level_2.tscn"), "isLevelCleared": false, "HighScore": 0, "isActive": false, "instance": null},
}

var reached_level: int = 0
var levelContainer: Node2D
signal levelLoaded

# Helper functions to work with levelsLibrary
func get_current_level() -> int:
	for level_number in levelsLibrary.keys():
		if levelsLibrary[level_number]["isActive"]:
			return level_number
	print("No active level found.")
	return 0  # No active level

func set_current_level(level_number: int):
	# Deactivate all levels first
	for level_num in levelsLibrary.keys():
		levelsLibrary[level_num]["isActive"] = false
	# Activate the specified level
	if levelsLibrary.has(level_number):
		levelsLibrary[level_number]["isActive"] = true

func get_current_level_instance() -> Node2D:
	var current_level = get_current_level()
	if current_level >= 0:
		return levelsLibrary[current_level]["instance"]
	return null

func load_level(level_number: int):
	# Remove all active balls
	for ball in Logic.balls.get_children():
		ball.queue_free()

	reached_level = max(reached_level, level_number)
	print("Reached level updated to: " + str(reached_level))

	# Unload the current level if it exists
	if get_current_level_instance() != null:
		unload_level()

	# show stage if not visible
	if !Logic.stage.visible:
		Logic.stage.show()

	# Set the new level as active
	set_current_level(level_number)

	# Instantiate and add new level
	var new_instance = levelsLibrary[level_number]["scene"].instantiate()
	levelsLibrary[level_number]["instance"] = new_instance
	levelContainer.add_child(new_instance)
	emit_signal("levelLoaded")
	print("Level loaded: " + str(level_number))
	Ui.update_ui()


func level_Restart():
	var current_level = get_current_level()
	if current_level >= 0:
		load_level(current_level)
		print("Level restarted: " + str(current_level))
	else:
		print("No active level to restart!")

func level_Next():
	var current_level = get_current_level()
	if current_level < 0:
		print("No active level!")
		return
	
	if levelsLibrary[current_level]["isLevelCleared"] == false:
		print("Current level is not cleared yet!")
		return
	
	var next_level = current_level + 1
	if levelsLibrary.has(next_level):
		load_level(next_level)
	else:
		print("No more levels!")

func level_Previous():
	var current_level = get_current_level()
	if current_level < 0:
		print("No active level!")
		return
	
	var previous_level = current_level - 1
	if levelsLibrary.has(previous_level):
		load_level(previous_level)
	else:
		print("No previous level!")

func unload_level():
	var current_level_instance = get_current_level_instance()
	var current_level = get_current_level()
	
	if current_level_instance and current_level_instance.get_parent() == levelContainer:
		levelContainer.remove_child(current_level_instance)
		current_level_instance.queue_free()
		if current_level >= 0:
			levelsLibrary[current_level]["instance"] = null
		print("Level unloaded: " + str(current_level))
	else:
		print("No level to unload.")

func level_Clear():
	var current_level = get_current_level()
	if current_level >= 0:
		levelsLibrary[current_level]["isLevelCleared"] = true
		levelsLibrary[current_level]["HighScore"] = Logic.score
		reached_level += 1
		SaveManager.save_game()
		print("Level cleared: " + str(current_level))
	else:
		print("No active level to clear!")

