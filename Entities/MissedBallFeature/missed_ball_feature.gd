extends Node2D

var coin_flip_success: bool

func _ready() -> void:
	Logic.missedBallFeature = self

func roll_for_new_ball():
	randomize()
	var random_bit = randi() % 2
	if random_bit == 1:
		coin_flip_success = true
		coin_flipping()
	elif random_bit == 0:
		coin_flip_success = false
		coin_flipping()
	else:
		print("Error: Invalid random bit value. for missed ball coin flip.")
		return
	
func coin_flipping():
	Logic.isGameStarted = false
	var sprite: Sprite2D = $Sprite2D
	var flash_count := 8
	var flash_time := 0.08
	var final_color := Color(0, 1, 0) if coin_flip_success else Color(1, 0, 0)
	var alt_color := Color(1, 0, 0) if coin_flip_success else Color(0, 1, 0)
	sprite.visible = true
	await _flash(sprite, flash_count, flash_time, final_color, alt_color)

	if coin_flip_success:
		#print("Coin flip successful!")
		Logic.addBall()

	else:
		#print("Coin flip failed.")
		if Logic.ballCount <= 0:
			Logic.GameOver()

	await get_tree().create_timer(.8).timeout
	sprite.visible = false
	Logic.isGameStarted = true

		

func _flash(sprite: Sprite2D, flash_count: int, flash_time: float, final_color: Color, alt_color: Color) -> void:
	for i in range(flash_count):
		sprite.modulate = final_color if i % 2 == 0 else alt_color
		await get_tree().create_timer(flash_time).timeout
	sprite.modulate = final_color
