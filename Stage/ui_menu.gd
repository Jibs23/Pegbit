extends VBoxContainer

var btn_retry: Button
var btn_next_level: Button
var btn_return_to_main_menu: Button
var txt_header: Label
var menuButtons: Control
var isMenuVisible: bool = false

signal gamePause
signal gameUnpause

func _ready() -> void:
	connect("gamePause", Callable(Logic, "_on_game_pause"))
	connect("gameUnpause", Callable(Logic, "_on_game_unpause"))
	menuButtons = $MenuButtons
	btn_retry =  menuButtons.get_node("BtnRetry")
	btn_next_level = menuButtons.get_node("BtnNextLevel")
	btn_return_to_main_menu = menuButtons.get_node("BtnMainMenu")
	txt_header = $TxtHeader

func toggle_menu(isForceShow = null) -> void:
	if isForceShow == null: # If no argument is passed, toggle the menu visibility
		self.visible = !self.visible
	else:
		self.visible = isForceShow

	isMenuVisible = self.visible
	if isMenuVisible:
		emit_signal("gamePause")
		if Logic.isGamePaused:
			txt_header.text = "PAUSE"
			btn_next_level.visible = false
		if Logic.isGameOver:
			txt_header.text = "GAME-OVER"
			btn_next_level.visible = false
		if Logic.levelClearedBonusMode:
			txt_header.text = "WINNER!"
			btn_next_level.visible = true
	else:
		emit_signal("gameUnpause")

func _input(event):
		if event.is_action_pressed("toggle_menu"):
			if !Logic.levelClearedBonusMode or !Logic.isGameOver:
				toggle_menu()
			else:
				print("cant toggle menu, stage is over")
				return
