extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 46
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
var direction = Vector3.ZERO

func calculate_movement(event: InputEvent):
	if event.is_action_pressed("forward"):
		direction.z = 1
	if event.is_action_pressed("backward"):
		direction.z = -1
	if event.is_action_pressed("left"):
		direction.x = 1
	if event.is_action_pressed("right"):
		direction.x = -1
	return direction.normalized()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			direction = calculate_movement(event)
		else:
			direction = Vector3.ZERO

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	print(position)
	move_and_slide()
