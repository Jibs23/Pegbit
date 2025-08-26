extends PathFollow2D

const START: int = 0
const MOVE_SPEED: float = .25
var goal: int
var progressAlongPath: float = 0.0
var sprite: Sprite2D

func _ready():
	sprite = $Sprite2D

func _physics_process(_delta):
	if Logic.level == null: return
	# 1.0 progress_ratio
	goal = Logic.level.levelRedPegs

	# how far along the path we are
	progressAlongPath = Logic.removedRedPegs

	# Tween the progress ratio to the next value
	var target_ratio = float(Logic.removedRedPegs - START) / (goal - START)
	if not has_node("Tween"):
		var tween = create_tween()
		tween.tween_property(self, "progress_ratio", target_ratio, MOVE_SPEED)
	else:
		get_node("Tween").kill()
		var tween = create_tween()
		tween.tween_property(self, "progress_ratio", target_ratio, MOVE_SPEED)
