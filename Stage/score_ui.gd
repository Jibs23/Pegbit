extends Node2D

var valueCount: Label
var chestSprite: Sprite2D
var levelUi: Node2D
const CHEST_MAX_SCORE: int = 500000 # this value is a placeholder. Adjust later.

func _ready() -> void:
	levelUi = get_parent()
	Ui.uiScoreCounter = self
	valueCount = $Score
	chestSprite = $Chest

var last_score := -1

func _process(_delta: float) -> void:
	if Logic.level == null or Logic.score == last_score: return# Only update if score changed and level is active
	last_score = Logic.score

	var chestFrameCount = chestSprite.hframes - 1
	var frame = 0
	if Logic.score > 0:
		frame = clamp(int(float(Logic.score - 1) / float(CHEST_MAX_SCORE - 1) * float(chestFrameCount)) + 1, 1, chestFrameCount)
	if chestSprite.frame != frame:
		chestSprite.set_frame(frame)

