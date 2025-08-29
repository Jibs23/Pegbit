extends UiMenu

var menu: Control
var menu_levels: Control
var btn_play: Button
var btn_exit: Button
var btn_save: Button
var btn_load: Button
var btn_erase: Button
var unlocked_all

func _ready() -> void:
	menu = $Menu
	btn_play = menu.get_node("BtnPlay")
	btn_exit = menu.get_node("BtnExit")
	btn_save = menu.get_node("BtnSave")
	btn_load = menu.get_node("BtnLoad")
	btn_erase = menu.get_node("BtnErase")
	menu_levels = menu.get_node("BtnLevels") 
	unlocked_all = get_node("Unlocked all!") as Sprite2D
	check_unlocked_levels()
	Logic.audio.music.song_play(Logic.audio.music.random_item_from_dic(Logic.audio.music.music_libraries["menu_music"]), Logic.audio.music.music_libraries["menu_music"])

func _on_btn_play_pressed() -> void:
	LevelsManager.load_level(LevelsManager.reached_level)
	await get_tree().process_frame
	Ui.clearActiveUi()

func _on_btn_levels_pressed() -> void:
	Ui.changeActiveUi("mainMenu_levels")

func _on_btn_save_pressed() -> void:
	SaveManager.save_game()

func _on_btn_load_pressed() -> void:
	SaveManager.load_save()

func _on_btn_erase_pressed() -> void:
	SaveManager.delete_save()

func _on_btn_exit_pressed() -> void:
	SaveManager.save_game()
	get_tree().quit()

func check_unlocked_levels() -> void:
	unlocked_all.visible = LevelsManager.unlocked_all_levels
