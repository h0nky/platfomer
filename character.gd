extends CharacterBody2D

const SPEED = 150
const JUMP_VELOCITY = 100
const GRAVITY = 400

@onready
var imagePlayer = get_node("character")

func change_player_direction():
	# Handling character's image flip
	if velocity.x < 0:
		imagePlayer.set_flip_h(true)
	elif velocity.x > 0:
		imagePlayer.set_flip_h(false)

func get_user_input():
	var direction = Input.get_axis("character_left", "character_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
 
func _physics_process(_delta):
	get_user_input()	
	move_and_slide()
	change_player_direction()
