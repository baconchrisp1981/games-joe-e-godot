extends Area3D

enum Type { HEALTH, SPEED, DAMAGE }

@export var type = Type.HEALTH
@export var amount = 25

var active = true
var rotation_speed = 2.0

func _ready():
	# Set color based on type
	var mesh = $MeshInstance3D
	match type:
		Type.HEALTH:
			mesh.material_override = StandardMaterial3D.new()
			mesh.material_override.albedo_color = Color.GREEN
		Type.SPEED:
			mesh.material_override = StandardMaterial3D.new()
			mesh.material_override.albedo_color = Color.YELLOW
		Type.DAMAGE:
			mesh.material_override = StandardMaterial3D.new()
			mesh.material_override.albedo_color = Color.RED

func _process(delta):
	if active:
		rotate_y(rotation_speed * delta)
		# Floating animation
		var t = Time.get_ticks_msec() / 500.0
		position.y = 0.5 + sin(t) * 0.2

func _on_body_entered(body):
	if not active:
		return
	
	if body.name == "Player" or body.is_in_group("player"):
		apply_powerup(body)
		queue_free()

func apply_powerup(player):
	match type:
		Type.HEALTH:
			player.health = min(player.health + amount, player.max_health)
			print("Health restored!")
		Type.SPEED:
			player.apply_speed_boost(amount)
			print("Speed boost!")
		Type.DAMAGE:
			player.apply_damage_boost(amount)
			print("Damage boost!")

func _on_body_exited(body):
	pass