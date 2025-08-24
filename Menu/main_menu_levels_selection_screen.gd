extends UiMenu

var menu: Control
var menu_levels: Control
var btn_back: Button

func _ready() -> void:
	menu = $Menu
	menu_levels = $MenuLevels
	btn_back = menu.get_node("BtnBack") 
	menu_levels.addLevelToMenu()
	btn_back.focus_neighbor_top = menu_levels.get_child(menu_levels.get_child_count() - 1).get_path()

func _on_btn_back_pressed() -> void:
	Ui.changeActiveUi("mainMenu")
