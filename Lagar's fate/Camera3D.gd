extends Camera3D
var parent
var mouse = Input.MOUSE_MODE_CAPTURED
var timer
var floor
# Called when the node enters the scene tree for the first time.
func cronometro(timer): # inicia o node "Timer"
	timer.autostart = false
	timer.wait_time = 1
	timer.set_one_shot(true)
	
func _ready():
	timer = get_node("Timer")
	Input.set_mouse_mode(mouse)
	parent = get_parent() as CharacterBody3D
	cronometro(timer)
	pass # Replace with function body.

func _process(delta):
	if parent.is_on_floor():
		if (floor == false and timer.get_time_left() == 0 and (rotation.x > 1.5 or rotation.x < -1.5)): 
			timer.start() #usado para correção de ângulo de câmera pós-pulos
		elif timer.get_time_left() > 0:
			floor = true
			rotation.x = lerp(rotation.x,0.314,0.05)
		else:
			floor = true
			rotation.x = clamp (rotation.x, -1.5, 1.5)
	else:
		floor = false
		pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("menu"):
		if mouse == Input.MOUSE_MODE_CAPTURED:
			mouse = Input.MOUSE_MODE_VISIBLE
		else:
			mouse = Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(mouse)

		
	if event is InputEventMouseMotion:
		
		parent.rotate(Vector3.UP, -event.relative.x * 0.001)
		rotate_object_local(Vector3.RIGHT, event.relative.y * -0.001)
		
	pass