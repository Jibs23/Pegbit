extends Node2D

var levelContainer: Node2D
var killZones: Node2D
var launcher: Node2D
var balls: Node2D
var border: Node2D
var walls: Node2D
var bucketTracker: Path2D
var missedBallFeature: Node2D
var bonusHoles: Node2D
var levelNumber: int

signal stageLoaded

func _init() -> void:
	self.connect("stageLoaded", Callable(LevelsManager, "_on_stage_loaded"))
	self.connect("stageLoaded", Callable(self, "_on_stage_loaded"))

	Logic.stage = self
	visible = false
	self.name = "Stage"

func _ready() -> void:
	levelContainer = $LevelContainer
	killZones = $Killzones
	launcher = $Launcher
	balls = $Balls
	border = $Border
	walls = $Walls
	bucketTracker = $"Bucket track"
	missedBallFeature = $MissedBallFeature
	bonusHoles = $BonusHoles
	Logic.bonusHoles.hide_bonus_holes()

func _on_level_loaded() -> void:
	visible = true
	print("Stage loaded: " + str(levelNumber))

func add_level(level_number:int):
	var new_level = LevelsManager.levelsLibrary[level_number]["scene"].instantiate()
	LevelsManager.set_current_level(level_number, new_level)
	get_node("LevelContainer").add_child(new_level)
	Logic.audio.music.song_play(Logic.audio.music.random_item_from_dic(Logic.audio.music.music_libraries["game_music"]), Logic.audio.music.music_libraries["game_music"])