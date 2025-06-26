extends VBoxContainer

var btn_play: Button
var btn_exit: Button
var btn_save: Button
var btn_load: Button
var btn_erase: Button
var mBtn_LevelSelect: MenuButton

func _ready() -> void:
	btn_play = $BtnPlay
	btn_exit = $BtnExit
	btn_save = $BtnSave
	btn_load = $BtnLoad
	btn_erase = $BtnErase
	mBtn_LevelSelect = $MBtnLevelSelect