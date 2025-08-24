extends Node2D

var extraballs_ui := {
	1: null,
	2: null,
	3: null
}

var extraballs_particle_effect :={
	1: null,
	2: null,
	3: null
}

func _ready() -> void:
	extraballs_ui[1] = $extraball1
	extraballs_ui[2] = $extraball2
	extraballs_ui[3] = $extraball3
	extraballs_particle_effect[1] = $GPUParticles2D1
	extraballs_particle_effect[2] = $GPUParticles2D2
	extraballs_particle_effect[3] = $GPUParticles2D3
	Logic.connect("ballScoreAdded", Callable(self, "_on_ball_score_added"))
	Logic.balls.connect("ballEnded", Callable(self, "_on_ball_ended"))
	Logic.connect("extra_ball_added", Callable(self, "_on_extra_ball_added"))

func update_extraballs_ui() -> void:
	var next_ball_number = Logic.nextExtraBallNumber()
	var next_ball_score = Logic.nextExtraBallScore()
	if next_ball_number == -1 or not extraballs_ui.has(next_ball_number):return
	if next_ball_score == -1 or next_ball_score == 0:return

	var ui_sprite: Sprite2D = extraballs_ui[Logic.nextExtraBallNumber()]
	var next_score = Logic.nextExtraBallScore()
	var current_score = Logic.ballScoreCounter
	var score_progress = float(current_score) / float(next_score)

	var frame_max = ui_sprite.hframes - 1
	# Calculate the frame based on score progress percentage
	var target_frame = int(score_progress * frame_max)
	ui_sprite.frame = clamp(target_frame, 0, frame_max)

func next_frame(extraball_ui:Sprite2D) -> void:
	if extraball_ui.frame < extraball_ui.hframes - 1:
		extraball_ui.frame += 1

func reset_frame(extraball_ui:Sprite2D) -> void:
	extraball_ui.frame = 0

func _on_ball_score_added(_amount) -> void:
	update_extraballs_ui()

func _on_ball_ended() -> void:
	reset_frame(extraballs_ui[1])
	reset_frame(extraballs_ui[2])
	reset_frame(extraballs_ui[3])

func _on_extra_ball_added(milestone: int, _milestone_data: Dictionary) -> void:
	extraballs_particle_effect[milestone].emitting = true
