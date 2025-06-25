extends Node2D

var bubbles_small: GPUParticles2D
var bubbles_medium: GPUParticles2D
var bubbles_large: GPUParticles2D
var transition_time: float = 1.8

func _ready():
	LevelsManager.levelTransition = self
	bubbles_small = $SBubbles
	bubbles_medium = $MBubbles
	bubbles_large = $LBubbles

func play_bubbles_effect():
	Logic.audio.playSoundEffect("SFXTransitionBubbleStart")
	Logic.audio.playSoundEffect("SFXTransitionBubble")
	bubbles_small.emitting = true
	bubbles_medium.emitting = true
	bubbles_large.emitting = true

func stop_bubbles_effect():
	var bubblesNode = Logic.audio.get_node("SFXTransitionBubble")
	bubbles_small.emitting = false
	bubbles_medium.emitting = false
	bubbles_large.emitting = false
	await get_tree().create_timer(transition_time*1.10).timeout
	if bubblesNode:
		var tween = create_tween()
		tween.tween_property(bubblesNode, "volume_db", -30, 2.5)
		tween.tween_callback(Callable(bubblesNode, "stop"))
		tween.tween_callback(func(): bubblesNode.volume_db = 0)
