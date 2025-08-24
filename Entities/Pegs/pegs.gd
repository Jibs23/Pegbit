@tool
extends Node2D

# Define the level requirement for red pegs
var pegsActivated: int = 0
var ballIsStuck: bool = false
func _enter_tree() -> void:
	if Engine.is_editor_hint():return
	Logic.pegs = self

func _ready():
	if Engine.is_editor_hint():return
	var level = Logic.level  
	var pegs: = []
	for child in get_children():
		if child is not Peg and child.get_child_count() > 0 and child.is_in_group("peg_group"):
			for sub_child in child.get_children():
				if sub_child is Peg:
					pegs.append(sub_child as Peg)
				elif sub_child.is_in_group("peg_group"):
					for sub_sub_child in sub_child.get_children():
						if sub_sub_child is Peg:
							pegs.append(sub_sub_child as Peg)

		else:
			pegs.append(child as Peg)
	pegs.shuffle()
	var red_peg_requirement: int = level.levelRedPegs	
	var red_pegs_assigned: int = 0
	var blue_pegs_assigned: int = 0

	for peg in pegs:
		if red_pegs_assigned < red_peg_requirement:
			peg.set_script(preload("res://Entities/Pegs/redPeg.gd"))
			red_pegs_assigned += 1
			callReady(peg)
		else:
			peg.set_script(preload("res://Entities/Pegs/bluePeg.gd"))
			blue_pegs_assigned += 1
			callReady(peg)
	
	#print("Red pegs: ", red_pegs_assigned)
	Logic.redPegCount = red_pegs_assigned

	#print("blue pegs: ", blue_pegs_assigned)
	Logic.bluePegCount = blue_pegs_assigned

	#print("Total pegs: ", len(pegs))
	Logic.totalPegCount = len(pegs)

func _on_hit_peg(peg):
	pegsActivated += 1
	Ui.update_ui()
	if peg.pegType == "red":
		var redPegs = get_tree().get_nodes_in_group("PegRed")
		var unhit_red_pegs = []
		for redPeg in redPegs:
			if redPeg is RedPeg and not redPeg.isHit:
				unhit_red_pegs.append(redPeg)
		if unhit_red_pegs.size() == 1:
			var last_peg = unhit_red_pegs[0]
			last_peg.particleCharged.emitting = true
			last_peg.pegIsLastRedPeg = true
			Logic.isOneRedPegRemaining = true
			#print("Last red peg set: ", last_peg.name)


func callReady(peg):
	if peg.has_method("_ready"):
		peg._ready()

var scene_peg: PackedScene = preload("res://Entities/Pegs/peg.tscn")
var scene_pegRect: PackedScene = preload("res://Entities/Pegs/peg_rect.tscn")

@export_group("Editor Tools")
@export_tool_button("Add Peg")
var button_add_peg = create_peg
@export_tool_button("Add Peg_Rect")
var button_add_pegRect = create_pegRect

func create_peg() -> void:
	var peg_instance = scene_peg.instantiate()
	peg_instance.name = "Peg"
	add_to_scene(peg_instance)

func create_pegRect() -> void:
	var pegRect_instance = scene_pegRect.instantiate()
	pegRect_instance.name = "Peg_rect"
	add_to_scene(pegRect_instance)

func add_to_scene(instance: Node2D) -> void:
	add_child(instance)
	instance.global_position = get_viewport().get_visible_rect().size / 2
	instance.owner = self
	print("Added " + instance.name + " at position: " + str(instance.global_position))
