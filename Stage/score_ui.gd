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

func _process(_delta: float) -> void:
	if Logic.level == null: return

	var chestFrameCount = chestSprite.hframes - 1
	var frame = 0
	if Logic.score > 0:
		frame = clamp(int(float(Logic.score - 1) / float(CHEST_MAX_SCORE - 1) * float(chestFrameCount)) + 1, 1, chestFrameCount)
	if chestSprite.frame != frame:
		chestSprite.set_frame(frame)

