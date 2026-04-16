extends Node

# Audio system - silent, ready for real audio files
# Add real audio files later to enable sound

# When adding audio:
# 1. Add files to res://assets/audio/sound_effects/
# 2. Add files to res://assets/audio/music/
# 3. Sounds will play automatically

var bg_music: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready():
	bg_music = AudioStreamPlayer.new()
	bg_music.name = "BackgroundMusic"
	bg_music.bus = "Master"
	add_child(bg_music)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.bus = "Master"
	add_child(sfx_player)

func play_sound(_sound_name: String):
	# No-op - add real audio files to enable
	pass

func stop_music():
	bg_music.stop()

func set_music_volume(_volume_db: float):
	pass

func set_sfx_volume(_volume_db: float):
	pass