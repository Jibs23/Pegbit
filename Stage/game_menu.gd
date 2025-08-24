extends UiMenu

var btn_retry: Button
var btn_return_to_main_menu: Button
var btn_next_level: Button = null
var txt_header: Label
var menu: Control

signal gamePause
signal gameUnpause

func _ready() -> void:
	menu = $Menu
	txt_header = $TxtHeader
	btn_retry =  menu.get_node("BtnRetry")
	btn_return_to_main_menu = menu.get_node("BtnMainMenu")
	update_menu()
	menu.get_child(0).grab_focus()
	connect("gamePause", Callable(Logic, "_on_game_pause"))
	connect("gameUnpause", Callable(Logic, "_on_game_unpause"))
	emit_signal("gamePause")

func _on_btn_retry_pressed() -> void:
	LevelsManager.level_Restart()

func _on_btn_next_level_pressed() -> void:
	LevelsManager.level_Next()
	self.queue_free()

func _on_btn_main_menu_pressed() -> void:
	LevelsManager.return_to_main_menu()

func update_menu() -> void:
	if LevelsManager.reached_level == LevelsManager.get_current_level() + 1:
		add_next_level_button()

	if Logic.levelClearedBonusMode:
		txt_header.text = "WINNER!"
		if menu.has_node("BtnNextLevel"): return
		add_next_level_button()

	elif Logic.isGameOver:
		txt_header.text = "GAME-OVER"
	elif Logic.isGamePaused:
		txt_header.text = "PAUSE"

func _on_tree_exiting() -> void:
	emit_signal("gameUnpause")

func add_next_level_button():
	btn_next_level = load(Ui.buttonsLibrary["BtnNextLevel"]["scene"]).instantiate()
	menu.add_child(btn_next_level)
	menu.move_child(btn_next_level, 0)	
