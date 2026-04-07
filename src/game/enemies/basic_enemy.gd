extends CharacterBody3D

const SPEED = 2.0
const ATTACK_RANGE = 1.5
const ATTACK_DAMAGE = 10
const HEALTH = 50

var health = HEALTH
var player = null
var state = "idle"  # idle, chase, attack
var can_attack = true

@onready var nav_agent = $NavigationAgent3D

func _ready():
	# Find the player in the scene
	await get_tree().create_timer(0.5).timeout
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta):
	match state:
		"idle":
			if player and is_player_in_range():
				state = "chase"
		"chase":
			if player:
				var direction = global_position.direction_to(player.global_position)
				velocity = direction * SPEED
				move_and_slide()
				
				if global_position.distance_to(player.global_position) < ATTACK_RANGE:
					state = "attack"
		"attack":
			if player and is_player_in_range():
				if can_attack:
					attack_player()
			else:
				state = "chase"
	
	# Face player
	if player:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

func is_player_in_range():
	var vision_area = $VisionArea
	var bodies = vision_area.get_overlapping_bodies()
	return player in bodies

func attack_player():
	can_attack = false
	player.take_damage(ATTACK_DAMAGE)
	await get_tree().create_timer(1.0).timeout
	can_attack = true

func take_damage(amount):
	health -= amount
	AudioManager.play_sound("hit")
	# Flash red
	var mesh = $MeshInstance3D
	var original_color = mesh.get_active_material(0).albedo_color if mesh.get_surface_override_material(0) else Color.GRAY
	
	var tween = create_tween()
	tween.tween_property(mesh, "surface_material_override/0:albedo_color", Color.RED, 0.1)
	tween.tween_property(mesh, "surface_material_override/0:albedo_color", original_color, 0.1)
	
	if health <= 0:
		die()

func die():
	AudioManager.play_sound("enemy_death")
	queue_free()