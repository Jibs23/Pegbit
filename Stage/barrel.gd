extends Node2D

var sprite_barrel: Sprite2D
var sprite_treasure: Sprite2D
var sprite_lid: Sprite2D
var animation_player: AnimationPlayer

func _ready() -> void:
	sprite_barrel = $SpriteBarrel
	sprite_treasure = $SpriteTreasure
	animation_player = $AnimationPlayer
	Logic.connect("ballScoreAdded", Callable(self, "_on_ball_score_added"))
	Logic.balls.connect("ballEnded", Callable(self, "_on_ball_ended"))
	Logic.launcher.connect("shoot_signal", Callable(self, "_on_ball_launched"))


func _on_ball_score_added(_amount) -> void:
	var treasure_frameCount = sprite_treasure.hframes - 1
	var progress := float(Logic.ballScoreCounter) / float(Logic.extraBallMilestones[3]["score"])
	progress = clamp(progress, 0.0, 1.0)

	var frame := int(progress * treasure_frameCount) + 1
	frame = clamp(frame, 0, treasure_frameCount - 1)
	if sprite_treasure.frame != frame:
		sprite_treasure.set_frame(frame)

func _on_ball_ended() -> void:
	if Logic.ballScoreCounter == 0:
		print("All balls have ended.")
		animation_player.play("barrel_full")

func _on_ball_launched() -> void:
	animation_player.play("RESET")

func play_closed_sound() -> void:
	Logic.audio.playSoundEffect("SFXBarrelClose")
