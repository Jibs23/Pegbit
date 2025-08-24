extends CanvasLayer
class_name UiMenu

signal menuToggled(visible: bool)

func _init():
	connect("menuToggled", Callable(self, "_on_menu_toggled"))

func toggle_menu(forceShow = null) -> void:
	if forceShow == null: # If no argument is passed, toggle the menu visibility
		self.visible = !self.visible
	else:
		self.visible = forceShow
	emit_signal("menuToggled", self.visible)