extends CharacterBody2D


@export var speed: float = 200.0
@export var jump_velocity: float = -200.0
@export var double_jump_velocity: float = -100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped: bool = false

@onready
var playerImage = get_node("Sprite")


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
			
	var direction = Input.get_axis("character_left", "character_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	# Handle sprite flip.
	if velocity.x < 0:
		playerImage.set_flip_h(true)
	elif velocity.x > 0:
		playerImage.set_flip_h(false)
	
