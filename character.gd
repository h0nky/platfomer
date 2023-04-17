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
var was_in_air: bool = false

@onready
var playerImage = get_node("CharacterSprite2D")


func _physics_process(delta):
	# Add the gravity. 
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jumped = false
		
		if was_in_air == true:
			land()
		
		was_in_air = false

	# Handle Jump.
	if Input.is_action_just_pressed("character_jump"):
		if is_on_floor():
			jump()
		elif not has_double_jumped:
			velocity.y = double_jump_velocity
			has_double_jumped = true
			
	direction = Input.get_vector("character_left", "character_right", "character_jump", "character_down")
	
	if direction.x !=0 && animated_sprite.animation != "jump_end":
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

func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_start")
	animation_locked = true

func land():
	animated_sprite.play("jump_end")
	animation_locked = true


func _on_character_sprite_2d_animation_finished():
	if(animated_sprite.animation == "jump_end"):
		animation_locked = false
