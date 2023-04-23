extends CharacterBody2D


@export var speed: float = 200.0
@export var jump_velocity: float = -200.0
@export var double_jump_velocity: float = -100

@onready var animated_sprite : AnimatedSprite2D = $CharacterSprite2D
@onready var animation_tree : AnimationTree = $AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped: bool = false
var animation_locked: bool = false
var direction: Vector2 = Vector2.ZERO
var was_in_air: bool = false

func _ready():
	animation_tree.active = true

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
			double_jump()
			
	direction = Input.get_vector("character_left", "character_right", "character_jump", "character_down")
	
	if direction.x !=0 && animated_sprite.animation != "jump_end":
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_character_direction()
	
func update_animation():
	animation_tree.set("parameters/Move/blend_position", direction.x)
	
	if not animation_locked:
		if not is_on_floor():
			animated_sprite.play("jump_loop")
		else:	
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

func double_jump():
	#Handle double jump in the air.
	velocity.y = double_jump_velocity
	animated_sprite.play("jump_double")
	animation_locked = true
	has_double_jumped = true

func land():
	animated_sprite.play("jump_end")
	animation_locked = true


func _on_character_sprite_2d_animation_finished():
	if(["jump_end", "jump_start", "jump_double"].has(animated_sprite.animation)):
		animation_locked = false
