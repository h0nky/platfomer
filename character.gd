extends CharacterBody2D


@export var speed: float = 200.0
@export var jump_velocity: float = -200.0
@export var double_jump_velocity: float = -100

@onready var animated_sprite : AnimatedSprite2D = $CharacterSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped: bool = false
var animation_locked: bool = false

var direction: Vector2 = Vector2.ZERO

@onready
var playerImage = get_node("CharacterSprite2D")


func _physics_process(delta):
	# Add the gravity. 
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		has_double_jumped = false

	# Handle Jump.
	if Input.is_action_just_pressed("character_jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif not has_double_jumped:
			velocity.y = double_jump_velocity
			has_double_jumped = true
			
	direction = Input.get_vector("character_left", "character_right", "character_jump", "character_down")
	
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_character_direction()
	
func update_animation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
			
func update_character_direction():
		# Handle sprite flip.
	if velocity.x < 0:
		playerImage.set_flip_h(true)
	elif velocity.x > 0:
		playerImage.set_flip_h(false)
