extends Node

var levelsLibrary: Dictionary = {
	0: {"scene": preload("res://Levels/level 0/level_0.tscn"), "isLevelCleared": false, "HighScore": 0},
	1: {"scene": preload("res://Levels/level 1/level_1.tscn"), "isLevelCleared": false, "HighScore": 0},
	2: {"scene": preload("res://Levels/level 2/level_2.tscn"), "isLevelCleared": false, "HighScore": 0},
}
#TODO: make level clear thing work propperly.

var current_level: int = 0
var current_level_instance: Node2D = null
var levelContainer: Node2D
signal levelLoaded

func load_level(level_number: int):
	# Remove all active balls
	for ball in Logic.balls.get_children():
		ball.queue_free()

	# Remove current level instance if it exists and is a child
	if current_level_instance and current_level_instance.get_parent() == levelContainer:
		levelContainer.remove_child(current_level_instance)
		current_level_instance.queue_free()

	# show stage if not visible
	if !Logic.stage.visible:
		Logic.stage.show()

	# Instantiate and add new level
	current_level_instance = levelsLibrary[level_number]["scene"].instantiate()
	levelContainer.add_child(current_level_instance)
	emit_signal("levelLoaded")
	print("Level loaded: " + str(level_number))
	Ui.update_ui()


func level_Restart():
	load_level(current_level)
	print("Level restarted: " + str(current_level))

func level_Next():
	if levelsLibrary[current_level]["isLevelCleared"] == false:
		print("Current level is not cleared yet!")
		return
	current_level += 1
	if levelsLibrary.has(current_level):
		load_level(current_level)
		current_level = current_level
	else:
		current_level -= 1
		print("No more levels!")

func level_Previous():
	current_level -= 1
	if levelsLibrary.has(current_level):
		load_level(current_level)
		current_level = current_level
	else:
		current_level += 1
		print("No previous level!")

func level_Clear():
	levelsLibrary[current_level]["isLevelCleared"] = true
	levelsLibrary[current_level]["HighScore"] = Logic.score
	print("Level cleared: " + str(current_level))
