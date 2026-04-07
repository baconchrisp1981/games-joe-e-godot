extends CharacterBody3D

const BASE_SPEED = 5.0
const BASE_RUN_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003
const ATTACK_COOLDOWN = 0.5
const ATTACK_DAMAGE = 25

# Powerup effects
var speed_multiplier = 1.0
var damage_multiplier = 1.0
var speed_boost_timer = 0.0
var damage_boost_timer = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_running = false
var can_attack = true
var health = 100
var max_health = 100

@onready var camera = $Camera3D
@onready var attack_area = $AttackArea

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Toggle running
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right") or event.is_action_pressed("move_up") or event.is_action_pressed("move_down"):
		is_running = Input.is_key_pressed(KEY_SHIFT)
	
	# Release mouse
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Attack
	if event.is_action_pressed("attack") and can_attack:
		perform_attack()

func _physics_process(delta):
	# Update powerup timers
	if speed_boost_timer > 0:
		speed_boost_timer -= delta
		if speed_boost_timer <= 0:
			speed_multiplier = 1.0
	
	if damage_boost_timer > 0:
		damage_boost_timer -= delta
		if damage_boost_timer <= 0:
			damage_multiplier = 1.0
	
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get movement input
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply movement with speed multiplier
	var current_speed = (BASE_RUN_SPEED if is_running else BASE_SPEED) * speed_multiplier
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()

func perform_attack():
	can_attack = false
	
	# Calculate damage with multiplier
	var actual_damage = int(ATTACK_DAMAGE * damage_multiplier)
	
	# Check for enemies in attack area
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(actual_damage)
	
	# Visual feedback - simple tween scale
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(1.2, 0.8, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector3(1, 1, 1), 0.1)
	
	# Cooldown timer
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true

func apply_speed_boost(amount: float):
	speed_multiplier = amount
	speed_boost_timer = 10.0  # 10 seconds

func apply_damage_boost(amount: float):
	damage_multiplier = amount
	damage_boost_timer = 10.0  # 10 seconds

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	# Simple respawn for now
	health = max_health
	position = Vector3(0, 1, 0)