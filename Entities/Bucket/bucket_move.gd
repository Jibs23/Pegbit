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
	LevelsManager.connect("levelLoaded", Callable(self, "_on_level_loaded"))
	_move_bucket()

# movement logic
func _move_bucket():
	var target = 1.0 if direction == 1 else 0.0 # 1 = right, 0 = left
	tween.tween_property(self, "progress_ratio", target, move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", _on_tween_finished)

# restart the tween when it finishes
func _on_tween_finished():
	direction *= -1 # toggle direction
	tween = create_tween()
	_move_bucket()

# reset the bucket to its initial position
func reset_bucket():
	print("Resetting bucket position")
	if tween:
		tween.stop()
		if tween.is_connected("finished", _on_tween_finished):
			tween.disconnect("finished", _on_tween_finished)
	progress_ratio = 0.0
	direction = 1
	path_following_node.global_position = global_position
	tween = create_tween() # Ensure a fresh tween
	_move_bucket()

func add_new_bucket():
	if Logic.bucket == null:
		var bucket_scene = load("res://Entities/Bucket/bucket.tscn")
		var bucket_instance = bucket_scene.instantiate()
		get_parent().add_child(bucket_instance)
		print("New bucket added to the scene.")
	else:
		print("Bucket already exists, not adding a new one.")

func _on_level_loaded():
	add_new_bucket()
	reset_bucket()
