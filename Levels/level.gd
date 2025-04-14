class_name Level
extends Node2D

@export var levelRedPegs: int
@export var levelBalls: int = 10

@onready var uiBallsCounter = get_tree().get_root().get_node("Game/Stage/game UI/VBoxContainer/Balls") as Label

# References to required child nodes
@onready var pegsGroup: Node = $PegsGroup
@onready var background: Sprite2D = $Background

func _ready() -> void:
    # Ensure required child nodes exist at runtime
    if pegsGroup == null:
        push_error(self.name + " is missing a 'PegsGroup' child node!")
    if background == null:
        push_error(self.name + " is missing a 'Background' Sprite2D child node!")

    # Initialize Logic variables
    Logic.redPegCount = levelRedPegs
    Logic.ballCount = levelBalls
    Logic.isGameStarted = true
    Logic.isGameOver = false
    Logic.isBallInPlay = false
    Logic.score = 0
    Logic.scoreMultiplier = 1
    Logic.ballCount = levelBalls
    Ui.update_ui()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("launcher_shoot") and Logic.isGameOver:
        get_tree().reload_current_scene()
