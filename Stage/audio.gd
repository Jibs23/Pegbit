extends Node2D

var audienceSoundEffectDisappointed: Node2D
var audienceSoundEffectExcited: Node2D
var music: Node2D

func _enter_tree() -> void:
	Logic.audio = self

func _ready() -> void:
	music = $MusicManager as Node2D

func playSoundEffect(effectName: String) -> AudioStreamPlayer2D:
	if !has_node(effectName): print("Error: Sound effect node not found: ", effectName)  # Check if the node exists
	var sound_effect = get_node(effectName)
	if !sound_effect or !sound_effect.has_method("play"):
		print("Error: Node found but does not have a 'play' method: ", effectName)
	sound_effect.play()
	return sound_effect

var distanceToPegLastFrame: float
var gettingCloserToPeg: bool
var lastPlayedSoundEffect

func buttons_connect_sound() -> void:
	if !Ui.userInterface.activeUi: 
		await Ui.userInterface.get_child(0).ready
	# asign move sfx
	for btn in Ui.userInterface.activeUi.find_children("*", "Button", true, false):
		if not btn.is_connected("focus_exited", Callable(self, "_on_button_focus_exited").bind(btn)):
			btn.connect("focus_exited", Callable(self, "_on_button_focus_exited").bind(btn))
		if not btn.is_connected("pressed", Callable(self, "playSoundEffect").bind("SFXMenuSelect")):
			btn.connect("pressed", Callable(self, "playSoundEffect").bind("SFXMenuSelect"))

func _on_button_focus_exited(btn: Button) -> void:
	if btn.is_inside_tree():
		playSoundEffect("SFXMenuMove")

### MUSIC ###


