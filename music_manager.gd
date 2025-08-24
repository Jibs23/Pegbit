extends Node2D


@export_group("Music Libraries") 
var music_libraries:Dictionary = {
	"game_music": {
		1: "res://Soundtrack/Stevia Sphere - A Mimir - 01 Raccoon Dreams.wav",
		2: "res://Soundtrack/Stevia Sphere - A Mimir - 02 Bed Full Of Shark Plushies.wav",
		3: "res://Soundtrack/Stevia Sphere - A Mimir - 03 On The Verge Of Autumn.wav"
	},
	"menu_music": {
		1: "res://Soundtrack/glaciære - two months of moments - 10 The Next Lips That Touch Mine.mp3"
	},
	"victory_music": {
		1:""
	}
}

var musicPlayer1 : AudioStreamPlayer2D

func _ready() -> void:
	musicPlayer1 = $MusicPlayer1

func song_play(song_number:int, song_library:Dictionary): 
	var music_player:AudioStreamPlayer2D = musicPlayer1
	music_player.stream = load(song_library[song_number])
	music_player.play()

func song_stop():
	musicPlayer1.stop()

func random_item_from_dic(library:Dictionary) -> int:
	var output = (randi() % library.size()) + 1 # picks a number between 1 and song_count.
	print("Random output: ", output)
	if output <= 0: 
		push_warning(library," contained no songs.")
		return -1
	return output

func get_current_song():
	musicPlayer1.get_stream()

func _on_music_player_1_finished() -> void:
	_on_song_finished()

func _on_song_finished() -> void:
	print("song finished")
