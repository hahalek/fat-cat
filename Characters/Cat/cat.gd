extends CharacterBody3D
const PLAYER_GRAVITY = 18
const SPEED = 4.0
const JUMP_VELOCITY = 400.5
var mouse_sensitivity := 0.002
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot = $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var cat_model = $Cat
@onready var colision_shape = $CollisionShape3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= PLAYER_GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"): # and is_on_floor()
		#$"../jump".play()
		velocity.y = JUMP_VELOCITY * delta
	
	#if Input.is_action_just_released("ui_accept"):
		#jump_cut()
		
		
	print(velocity.y)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#play_walk_sound()
		velocity.x = - direction.x * SPEED
		velocity.z = - direction.z * SPEED
		#print(direction)
		var cat_vec = - Vector2(direction.x, direction.z)
		var cat_angle = rad_to_deg(cat_vec.angle())

		cat_model.rotation_degrees.y = - cat_angle + 90
		colision_shape.rotation_degrees.y = - cat_angle + 90
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_just_pressed("cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		-0.5,
		0.5
	)
	
	twist_input = 0.0
	pitch_input = 0.0
	
	
	move_and_slide()

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = event.relative.y * mouse_sensitivity
