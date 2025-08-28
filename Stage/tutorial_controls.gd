extends Sprite2D

var hide_timer := Timer.new()

func _ready():
	add_child(hide_timer)
	hide_timer.wait_time = 30.0
	hide_timer.one_shot = true
	hide_timer.connect("timeout", Callable(self, "_on_hide_timer_timeout"))
	Logic.launcher.connect("shoot_signal", Callable(self, "_on_shoot"))
	self.modulate.a = 0.5  # Set alpha to 50% transparency

	if LevelsManager.reached_level == 0:
		show()
	else:
		hide()

func _process(_delta):
	if not visible:
		return
	else:
		if not hide_timer.is_stopped():
			return
		hide_timer.start()

func _on_hide_timer_timeout():
	show()

func _on_shoot():
	hide()
	hide_timer.start()