class_name Trail
extends Line2D

const TRAIL_LENGHT_FEVER: int = 30
const TRAIL_LENGHT_DEFAULT: int = 10
var trail_lenght: int = TRAIL_LENGHT_DEFAULT
@onready var curve := Curve2D.new()

func _ready() -> void:
	position = Vector2.ZERO

func _process(_delta: float) -> void:
	curve.add_point(get_parent().position)
	if Logic.levelClearedBonusMode:
		trail_lenght = TRAIL_LENGHT_FEVER
	else:
		trail_lenght = TRAIL_LENGHT_DEFAULT
	if curve.get_baked_points().size() > trail_lenght:
		curve.remove_point(0)
	points = curve.get_baked_points()

func stop() -> void:
	set_process(false)
	var tw := get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 3.0)
	await tw.finished
	queue_free()

static func start_trail() -> Trail:
	var trail = preload("res://Entities/Balls/Trail/trail.tscn")
	return trail.instantiate()
