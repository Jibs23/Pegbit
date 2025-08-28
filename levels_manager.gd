extends Node

var levelsLibrary: Dictionary = {
	0: {"scene": preload("res://Levels/level 0/level_0.tscn"), "isLevelCleared": false, "HighScore": 0, "isActive": false,"instance": null},
	1: {"scene": preload("res://Levels/level 1/level_1.tscn"), "isLevelCleared": false, "HighScore": 0, "isActive": false,"instance": null},
	2: {"scene": preload("res://Levels/level 2/level_2.tscn"), "isLevelCleared": false, "HighScore": 0, "isActive": false,"instance": null},
	3: {"scene": preload("res://Levels/level 3/level_3.tscn"), "isLevelCleared": false, "HighScore": 0, "isActive": false,"instance": null},
	4: {"scene": preload("res://Levels/level 4/level_4.tscn"), "isLevelCleared": false, "HighScore": 0, "isActive": false,"instance": null}
}

var gameStage: PackedScene = preload("res://Stage/stage.tscn")
var reached_level: int = 0
var levelTransition: Node2D
var unlocked_all_levels: bool = false
signal levelLoaded
signal gameUnpause

func _init() -> void:
	connect("gameUnpause", Callable(Logic, "_on_game_unpause"))

# Helper functions to work with levelsLibrary
func get_current_level() -> int:
	for level_number in levelsLibrary.keys():
		if levelsLibrary[level_number]["isActive"]:
			return level_number
	push_error("No active level found in levelsLibrary. "+str(get_stack()))
	return -1  # No active level

func get_current_level_instance() -> Node:
	var current_level = get_current_level()
	if levelsLibrary.has(current_level):
		return levelsLibrary[current_level]["instance"]
	else:
		push_error("Current level instance not found.")
		return null

func set_current_level(level_number: int, level_instance: Node = null):
	# Deactivate all levels first
	for level_num in levelsLibrary.keys():
		levelsLibrary[level_num]["isActive"] = false
		if levelsLibrary[level_num]["instance"] and is_instance_valid(levelsLibrary[level_num]["instance"]):
			unload_level(levelsLibrary[level_num]["instance"])
			print("Instance of level " + str(level_num) + " freed.")
	
	# Activate the specified level
	if levelsLibrary.has(level_number):
		levelsLibrary[level_number]["isActive"] = true
		levelsLibrary[level_number]["instance"] = level_instance
		print("Level " + str(level_number) + " set as active")

func load_level(level_number: int):
	if levelTransition.transitionActive:
		print("Level transition is already active, cannot load new level.")
		return

	if levelsLibrary.has(level_number) == false:
		push_error("Level " + str(level_number) + " does not exist in levelsLibrary.")
		return

	levelTransition.play_bubbles_effect()

	# Remove all, if any, active balls
	if Logic.balls and Logic.balls.get_child_count() > 0:
		for ball:Ball in Logic.balls.get_children():
			ball.queue_free()

	await get_tree().create_timer(levelTransition.transition_time).timeout	

	# Unload the current stage if it exists
	if Logic.stage: unload_stage()
	var stage_instance = gameStage.instantiate()
	stage_instance.name = "Stage"
	Logic.game.add_child(stage_instance)
	Logic.stage.visible = false

	var new_level = levelsLibrary[level_number]["scene"].instantiate()
	set_current_level(level_number, new_level)
	Logic.stage.levelContainer.add_child(new_level)
	
	Logic.stage.visible = true
	Logic.audio.music.song_play(Logic.audio.music.random_item_from_dic(Logic.audio.music.music_libraries["game_music"]), Logic.audio.music.music_libraries["game_music"])
	emit_signal("levelLoaded")
	levelTransition.stop_bubbles_effect()

func level_Restart():
	print("Level restarted: " + str(get_current_level()))
	Ui.clearActiveUi()
	Logic.isGameStarted = false
	load_level(get_current_level())

func level_Next():
	var current_level = get_current_level()
	if current_level < 0:
		push_error("No active level!")
		return
	
	if levelsLibrary[current_level]["isLevelCleared"] == false:
		print("Current level is not cleared yet!")
		return
	
	var next_level = current_level + 1
	if levelsLibrary.has(next_level):
		load_level(next_level)
	else:
		return_to_main_menu()
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

func unload_level(level_instance: Node2D = null):
	for level_number in levelsLibrary.keys():
		if levelsLibrary[level_number]["instance"] == level_instance:
			print("Level " + str(level_number) + " unloaded.")
			levelsLibrary[level_number]["isActive"] = false
			levelsLibrary[level_number]["instance"].get_parent().remove_child(levelsLibrary[level_number]["instance"])
			levelsLibrary[level_number]["instance"] = null
			level_instance.queue_free()
			break

func unload_stage():
	if Logic.stage and Logic.stage.get_parent() == Logic.game:
		Logic.stage.queue_free()
		#print("Stage unloaded.")
	else:
		push_error("No stage to unload.")

func level_Clear():
	var current_level = get_current_level()
	reached_level = max(reached_level, current_level+1)
	levelsLibrary[current_level]["isLevelCleared"] = true
	levelsLibrary[current_level]["HighScore"] = max(Logic.score, levelsLibrary[current_level]["HighScore"])
	SaveManager.save_game()
	print("Level cleared: " + str(current_level))

func return_to_main_menu():
	levelTransition.play_bubbles_effect()
	Logic.isGameStarted = false
	Logic.isGameOver = false
	Ui.clearActiveUi()
	await get_tree().create_timer(levelTransition.transition_time).timeout
	unload_stage()
	Ui.changeActiveUi("mainMenu")
	print("Returned to main menu.")
	levelTransition.stop_bubbles_effect()

func unlock_all_levels():
	var all_unlocked = true
	unlocked_all_levels = true
	reached_level = levelsLibrary.keys().size()-1
	for level in levelsLibrary.keys():
		if levelsLibrary[level]["isLevelCleared"] == false:
			levelsLibrary[level]["isLevelCleared"] = true
			all_unlocked = false
			print("Level " + str(level+1) + " unlocked.")
	if not all_unlocked:
		Logic.audio.playSoundEffect("SFXCrowdCheer")
