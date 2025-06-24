extends MenuButton

var popup: PopupMenu

func _ready() -> void:
	popup = get_popup()
	popup.connect("id_pressed", Callable(self, "_on_level_selected"))
	SaveManager.connect("saveDataSaved", Callable(self, "_on_game_saved"))
	add_levels_to_dropdown()
	update_level_selection()

func add_levels_to_dropdown() -> void:
	for level in LevelsManager.levelsLibrary.keys():
		var level_name = "Level " + str(level)
		popup.add_item(level_name, level)

func update_level_selection() -> void:
	for level in LevelsManager.levelsLibrary.keys():
		var locked_level = level > LevelsManager.reached_level
		popup.set_item_disabled(level, locked_level)

func _on_level_selected(level: int) -> void:
	LevelsManager.load_level(level)
	Logic.userInterface.mainMenu.toggleMainMenu()

func _on_pressed() -> void:
	update_level_selection()
	print("Level selection button pressed, updating dropdown.")
