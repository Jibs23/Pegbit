extends RigidBody2D


signal out_of_bounds
var offScreenChecker: VisibleOnScreenNotifier2D
var smokeEffect: GPUParticles2D

func _ready() -> void:
	smokeEffect = $SmokeEffect
	connect("out_of_bounds", Callable(get_parent(), "_on_uiBall_out_of_bounds"))

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	emit_signal("out_of_bounds")
	push_warning(name + " has gotten out of bounds, removing from " + get_parent().name)
