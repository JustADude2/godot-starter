extends CharacterBody2D

@export var move_speed := 220.0
@export var jump_velocity := -350.0
@export var gravity := 900.0
@export var aura := 1000000

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * move_speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()

func _camera_boundary(top: Vector2, right: Vector2, bottom: Vector2, left: Vector2) -> void:
	var camera := %Camera2D
	
	camera.limit_bottom = bottom.y
	camera.limit_top = top.y
	camera.limit_left = left.x
	camera.limit_right = right.x
