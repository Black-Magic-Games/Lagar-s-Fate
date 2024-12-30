extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const running = 8.5
const maxjumps = 2
var has_jumped
var isdashing
var dashcooldown
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func dashstart(isdashing):
	isdashing.autostart = false
	isdashing.wait_time = 0.2
	isdashing.set_one_shot(true)
func _ready():
	isdashing = get_node("Timer")
	dashstart(isdashing)
	dashcooldown = get_node("dashcld")
	dashcooldown.autostart = false
	dashcooldown.wait_time = 1.2
	dashcooldown.set_one_shot(true)
	pass
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if is_on_wall_only():
			velocity.y -= gravity * delta /5
		else:
			velocity.y -= gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (has_jumped < maxjumps):
		velocity.y = JUMP_VELOCITY
		has_jumped += 1
	
	if is_on_floor():
		has_jumped = 0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var truespeed
	if direction:
		if Input.is_action_pressed("shift"):
			truespeed = running
		else:
			truespeed = SPEED
		if Input.is_action_pressed("E") and isdashing.is_stopped() == true and dashcooldown.is_stopped() == true:
				isdashing.start()
				dashcooldown.start()
		if isdashing.is_stopped() == false:
			truespeed = 23
		velocity.x = direction.x * truespeed
		velocity.z = direction.z * truespeed
	else:
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
