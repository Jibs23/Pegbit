extends Button



func _on_pressed() -> void:
	Logic.audio.music.song_play(Logic.audio.music.random_item_from_dic(Logic.audio.music.music_libraries["game_music"]), Logic.audio.music.music_libraries["game_music"])
