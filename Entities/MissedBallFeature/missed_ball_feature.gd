extends Node2D

var animation: AnimationPlayer
var sprite: Sprite2D
var animation_coin_flip_success:String = "flip_long_win"
var animation_coin_flip_failure:String = "flip_long_lose"

func _ready() -> void:
	Logic.missedBallFeature = self
	animation = $AnimationPlayer
	sprite = $Sprite2D

func roll_for_new_ball():
	randomize()
	var random_bit = randi() % 2
	var coin_flip_success: bool
	if random_bit == 1:
		coin_flip_success = true
		coin_flipping(coin_flip_success)
	elif random_bit == 0:
		coin_flip_success = false
		coin_flipping(coin_flip_success)
	else:
		print("Error: Invalid random bit value. for missed ball coin flip.")
		return

func coin_flipping(coin_flip_success: bool):
	Logic.isGameStarted = false
	sprite.visible = true
	Logic.audio.playSoundEffect("SFXCoinToss")
	Logic.audio.playSoundEffect("SFXCoinFlip")

	if coin_flip_success:
		print("Coin flip successful!")
		animation.play(animation_coin_flip_success)
		await animation.animation_finished

	else:
		print("Coin flip failed.")
		animation.play(animation_coin_flip_failure)
		await animation.animation_finished
		if Logic.ballCount <= 0:
			Logic.GameOver()

	if coin_flip_success: Logic.addBall()
	Logic.isGameStarted = true
	await get_tree().create_timer(1).timeout
	if !Logic.isGameOver: sprite.visible = false

func sound_fail():
	Logic.audio.playSoundEffect("SFXSad")

func sound_win():
	Logic.audio.playSoundEffect("SFXExtraBall")
