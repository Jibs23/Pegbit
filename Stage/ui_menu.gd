extends VBoxContainer

var btn_retry: Button
var btn_next_level: Button
var btn_previous_level: Button
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
	btn_previous_level = menuButtons.get_node("BtnPreviousLevel")
	txt_header = $TxtHeader

func toggle_menu(isForceShow = null) -> void:
	if isForceShow == null: # If no argument is passed, toggle the menu visibility
		self.visible = !self.visible
	else:
		self.visible = isForceShow

	isMenuVisible = self.visible
	if Logic.isGameOver:
		txt_header.text = "GAME-OVER"
		btn_next_level.disabled = true
	else:
		txt_header.text = "PAUSE"
	if Logic.levelClearedBonusMode:
		txt_header.text = "WINNER!"
		btn_next_level.disabled = false
	else:
		print("SOMETHING WENT WRONG WITH ui_menu.gd.toggle_menu()")
	if isMenuVisible:
		emit_signal("gamePause")
	else:
		emit_signal("gameUnpause")

func _input(event):
	if Logic.levelClearedBonusMode or Logic.isGameOver:
		print("cant toggle menu, stage is beaten")
		return 
	if event.is_action_pressed("toggle_menu"):
		toggle_menu()
