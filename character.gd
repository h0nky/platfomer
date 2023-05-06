extends CharacterBody2D

@export var speed: float = 200.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked: bool = false
var direction: Vector2 = Vector2.ZERO
var was_in_air: bool = false

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Add the gravity. 
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		if was_in_air == true:
			land()
		
		was_in_air = false
			
	direction = Input.get_vector("character_left", "character_right", "character_jump", "character_down")
	
	if direction.x !=0 && state_machine.check_if_can_move(): 
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_character_direction()
	
func update_animation():
	animation_tree.set("parameters/Move/blend_position", direction.x)
	

func update_character_direction():
		# Handle sprite flip.
	if velocity.x < 0:
		sprite.set_flip_h(true)
	elif velocity.x > 0:
		sprite.set_flip_h(false)

func land():
	#animated_sprite.play("jump_end")
	animation_locked = true


#func _on_character_sprite_2d_animation_finished():
	#if(["jump_end", "jump_start", "jump_double"].has(animated_sprite.animation)):
		#animation_locked = false
