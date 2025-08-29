extends Node
var uiBallsCounter
var uiMaxBalls
var uiScoreCounter
var uiMultiplierCounter
var uiScoreCounterBall
var uiCurrentLevel


var userInterface: CanvasLayer

var buttonsLibrary: Dictionary = {
	"BtnNextLevel": {"name": "btn_next_level", "scene": "res://Menu/btn_next_level.tscn"},
}

var menusLibrary: Dictionary = {
	"gameMenu": {"name": "gameMenu", "scene": "res://Menu/game_menu.tscn"},
	"mainMenu": {"name": "mainMenu", "scene": "res://Menu/main_menu.tscn"},
	"mainMenu_levels": {"name": "mainMenu_levels", "scene": "res://Menu/main_menu_levels.tscn"}
}

signal gameUnpause

func _init() -> void:
	connect("gameUnpause", Callable(Logic, "_on_game_unpause"))

func changeActiveUi(changeTo):
	if userInterface.activeUi: clearActiveUi()
	var scene_path = menusLibrary[changeTo]["scene"]
	var packed_scene = load(scene_path)
	var new_ui_instance = packed_scene.instantiate()
	userInterface.add_child(new_ui_instance)
	userInterface.activeUi = new_ui_instance
	print("New UI instance: " + new_ui_instance.name + " added to userInterface.")

	if new_ui_instance.has_node("Menu"):
		new_ui_instance.get_node("Menu").get_child(0).grab_focus()
	else:
		push_warning("New UI instance "+new_ui_instance.name+" does not have a 'menu' node to grab focus.")

func clearActiveUi():
	if userInterface.activeUi:
		userInterface.activeUi.queue_free()
		userInterface.activeUi = null
	else:
		push_warning("No active UI to clear.")

func update_ui() -> void:
	var ui_elements = [
			{"label": uiBallsCounter.valueCount if uiBallsCounter else null, "value": Logic.ballCount},
			{"label": uiMultiplierCounter.valueCount if uiMultiplierCounter else null, "value": Logic.scoreMultiplier},
			{"label": uiScoreCounter.valueCount if uiScoreCounter else null, "value": Logic.score},
			{"label": uiScoreCounterBall.valueCount if uiScoreCounterBall else null, "value": Logic.ballScoreCounter},
			{"label": uiCurrentLevel.valueCount if uiCurrentLevel else null, "value": int(LevelsManager.get_current_level()+1)},
		]
	for element in ui_elements:
		if element["label"] == null or element["value"] == null:
			# push_error("Label: " + str(element["label"]) + " Value: " + str(element["value"]) + " cannot update UI.")
			break
		var label:Label = element["label"]
		var value:int = element["value"]
		if label == uiMultiplierCounter.valueCount:
			label.text = "x" + str(value)
			continue
		label.text = str(value)
	
	if Logic.ballsUI:
		Logic.ballsUI.call_deferred("maintainBallCount")

func etsablishFocus():
	# asign default focus
	await userInterface.ready
	if userInterface.activeUi == null: 
		push_error("No active UI to establish focus on.")
		return
	for container in userInterface.activeUi.find_children("*", "Control", true, false):
		if container.find_children("*", "Button", true, false):
			var button_all = container.find_children("*", "Button", true, false)
			for button in button_all:
				if button.has_meta("FocusByDefault") and button.get_meta("FocusByDefault"):
					button.grab_focus()
					print("Focus established on: " + button.name)
					return
