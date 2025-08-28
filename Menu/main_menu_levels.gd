extends GridContainer

const BUTTON_SIZE = 24

func _ready() -> void:
	for btn: Button in get_children():
		btn.focus_exited.connect(Callable(Logic.audio, "playSoundEffect_menu_button_move").bind(btn))
	#print("reacehd level = "+str(LevelsManager.reached_level))

func on_button_pressed(levels) -> void:
	Ui.clearActiveUi()
	LevelsManager.load_level(levels)

func addLevelToMenu() -> void:
	for levels in LevelsManager.levelsLibrary:
		var button = Button.new()
		button.pressed.connect(func(): on_button_pressed(levels))
		button.text = str(int(levels)+1)
		add_child(button)
		button.focus_neighbor_bottom = get_parent().btn_back.get_path()
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.custom_minimum_size = Vector2(BUTTON_SIZE, BUTTON_SIZE)
		if levels > LevelsManager.reached_level:
			button.disabled = true
			#print("Button for level: "+ str(levels) + " is disabled, as it is not yet reached.")
		else:
			button.disabled = false
			#print("Button for level: "+ str(levels) + " is enabled.")
		#print("Added button for level: "+ str(levels))
