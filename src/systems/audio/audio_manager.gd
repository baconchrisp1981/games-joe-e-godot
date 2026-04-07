extends Node

# Audio system - handles all game sounds
# Uses placeholder paths - will fail silently if files don't exist

var bg_music: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var sounds = {
	"attack": "res://assets/audio/sound_effects/attack.wav",
	"hit": "res://assets/audio/sound_effects/hit.wav",
	"enemy_death": "res://assets/audio/sound_effects/enemy_death.wav",
	"powerup": "res://assets/audio/sound_effects/powerup.wav",
	"player_death": "res://assets/audio/sound_effects/player_death.wav",
	"step": "res://assets/audio/sound_effects/step.wav"
}

func _ready():
	bg_music = AudioStreamPlayer.new()
	bg_music.name = "BackgroundMusic"
	bg_music.bus = "Master"
	add_child(bg_music)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.bus = "Master"
	add_child(sfx_player)
	
	play_background_music()

func play_background_music():
	var bgm_path = "res://assets/audio/music/lab_ambient.mp3"
	if ResourceLoader.exists(bgm_path):
		bg_music.stream = load(bgm_path)
		bg_music.volume_db = -10
		bg_music.play()
	else:
		print("Background music not found - skipping")

func play_sound(sound_name: String):
	var path = sounds.get(sound_name, "")
	if path != "" and ResourceLoader.exists(path):
		sfx_player.stream = load(path)
		sfx_player.play()
	else:
		# Silent fail - no sound plays, no error
		pass

func stop_music():
	bg_music.stop()

func set_music_volume(volume_db: float):
	bg_music.volume_db = volume_db

func set_sfx_volume(volume_db: float):
	sfx_player.volume_db = volume_db