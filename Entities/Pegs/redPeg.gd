class_name RedPeg
extends Peg

var particleImpact: GPUParticles2D
var pegIsLastRedPeg: bool = false
var particleCharged
signal hitLastRedPeg

func _ready():
	particleCharged = $RedParticleCharged
	particleImpact = $ParticleImpact
	connect("hitLastRedPeg", Callable(Logic, "_on_hitLastRedPeg"))
	pegCount = Logic.redPegCount
	pegType = "red"
	litColor = spriteSheetNr["red_lit"]
	get_node("Sprite2D").set_frame(spriteSheetNr["red"])
	add_to_group("PegRed")
	
	scoreValue = 100

func hit():
	if pegIsLastRedPeg:
		print("Last red peg hit! " + self.name)
		particleImpact.emitting = true
		emit_signal("hitLastRedPeg")

	super() # Call the parent hit method
