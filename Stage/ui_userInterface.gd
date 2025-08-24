extends CanvasLayer

var activeUi: UiMenu = null

func _ready() -> void:
	Ui.userInterface = self
	if !activeUi: Ui.changeActiveUi("mainMenu")

func _on_tree_exiting() -> void:
	var caller = get_script().get_instance_id()
	push_warning("userInterface is being deleted!!!!! Called by: caller: " + str(caller))

func _input(event): #toggle the game menu
		if !Logic.stage or !Logic.level: return
		if event.is_action_pressed("toggle_menu"):
			if !Logic.levelClearedBonusMode and !Logic.isGameOver and !Logic.isBulletTimeActive:
				if Logic.isGamePaused:
					Ui.clearActiveUi()
				else:
					Ui.changeActiveUi("gameMenu")
			else:
				print("cant toggle menu, stage is over")
				return

func _on_child_entered_tree(child) -> void:
	if child.get_parent() == self:
		Logic.audio.call_deferred("buttons_connect_sound")
		Ui.call_deferred("etsablishFocus")
