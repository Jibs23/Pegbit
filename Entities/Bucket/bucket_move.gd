extends PathFollow2D

@export var move_duration: float = 3.5
@export var path_following_node: Node2D
var tween: Tween
var direction := 1

func _physics_process(_delta):
	if path_following_node:
		path_following_node.global_position = global_position

	if not Logic.isBucketMove and tween.is_running():
		tween.pause()
	elif Logic.isBucketMove and not tween.is_running():
		tween.play()

func _ready():
	tween = create_tween()
	_move_bucket()

# movement logic
func _move_bucket():
	var target = 1.0 if direction == 1 else 0.0 # 1 = right, 0 = left
	tween.tween_property(self, "progress_ratio", target, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", _on_tween_finished)

# restart the tween when it finishes
func _on_tween_finished():
	direction *= -1
	tween = create_tween()
	_move_bucket()
