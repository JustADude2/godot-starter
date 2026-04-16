class_name Player
extends CharacterBody2D

@export var move_speed := 220.0
@export var jump_velocity := -350.0
@export var gravity := 900.0
@export var cam_bound_top: CollisionShape2D
@export var cam_bound_right: CollisionShape2D
@export var cam_bound_bottom: CollisionShape2D
@export var cam_bound_left: CollisionShape2D

enum PlayerStates {
	IDLE,
	WALKING,
	FALLING,
	JUMPING
}

var current_state: PlayerStates = PlayerStates.IDLE

func _ready() -> void:
	set_camera_boundary()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	$sprite/shadow.play($sprite.animation)
	$sprite/shadow.frame = $sprite.frame
	$sprite/shadow.set_flip_h($sprite.flip_h)
	
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * move_speed
	
	if direction == 1:
		$sprite.set_flip_h(false)
		$sprite.position.x = 12.0
		$sprite.play("default")
	else: 
		if direction == -1:
			$sprite.set_flip_h(true)
			$sprite.play("default")
			$sprite.position.x = -12.0
		
		else:
			$sprite.play("new_animation")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	#determine state
	if not is_on_floor():
		current_state = PlayerStates.FALLING if velocity.y >= 0 else PlayerStates.JUMPING
	elif velocity.x != 0:
		current_state = PlayerStates.WALKING
	else:
		current_state = PlayerStates.IDLE
	
	move_and_slide()

func set_camera_boundary() -> void:
	var camera := %Camera2D
	if cam_bound_top != null:
		camera.limit_top = cam_bound_top.position.y
	
	if cam_bound_right != null:
		camera.limit_right = cam_bound_right.position.x
	
	if cam_bound_bottom != null:
		camera.limit_bottom = cam_bound_bottom.position.y
	
	if cam_bound_left != null:
		camera.limit_left = cam_bound_left.position.x
